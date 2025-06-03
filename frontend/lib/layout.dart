import 'package:flutter/material.dart';

import 'home.dart';
import 'notification.dart';
import 'gift.dart';
import 'profile.dart';
import 'navbar.dart';

class MainPageLayout extends StatefulWidget {
  final int initialIndex;

  const MainPageLayout({super.key, this.initialIndex = 0});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  late int _currentIndex;
  bool _resetHome = false;
  bool _resetProfile = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onResetHomeComplete() {
    setState(() {
      _resetHome = false;
    });
  }

  void _onResetProfileComplete() {
    setState(() {
      _resetProfile = false;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      if (index == 0 && _currentIndex == 0) {
        _resetHome = true;
      }
      if (index == 2 && _currentIndex == 2) {
        _resetProfile = true;
      }
      _currentIndex = index;
    });
  }

  List<Widget> get screens => [
    HomeScreen(resetToMain: _resetHome, onResetComplete: _onResetHomeComplete),
    const NotificationScreen(),
    ProfileScreen(
      resetToMain: _resetProfile,
      onResetComplete: _onResetProfileComplete,
    ),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: KeyedSubtree( // Helps differentiate widgets
        key: ValueKey<int>(_currentIndex),
        child: screens[_currentIndex],
      ),
    ),
    bottomNavigationBar: ConvexNavBar(
      currentIndex: _currentIndex,
      onTap: _onTabChanged,
    ),
  );
}
}
