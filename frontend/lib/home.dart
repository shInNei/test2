import 'package:flutter/material.dart';

import 'home_rank.dart'; // this is just a widget, not a scaffold
import 'practice_screen.dart'; // this too
import 'ranked.dart';

class HomeScreen extends StatefulWidget {
  final bool resetToMain;
  final VoidCallback? onResetComplete;

  const HomeScreen({super.key, this.resetToMain = false, this.onResetComplete});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentSubscreen = 'main'; // can be 'main', 'rank', or 'practice'

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetToMain && !oldWidget.resetToMain) {
      setState(() {
        _currentSubscreen = 'main';
      });

      // Notify parent that reset has completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onResetComplete?.call();
      });
    }
  }

  void _showSubscreen(String screen) {
    setState(() {
      _currentSubscreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_currentSubscreen == 'rank') {
      content = HomeRankScreen(onShowRanked: () => _showSubscreen("ranked"));
    } else if (_currentSubscreen == 'ranked') {
      content = RankedScreen(onBack: () => _showSubscreen('rank'));
    } else if (_currentSubscreen == 'practice') {
      content = PracticeScreen(onBack: () => _showSubscreen('main'));
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'IQ Tranh Đấu',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 20),
          Image.asset('assets/images/logo.png', height: 250),
          const SizedBox(height: 16),
          const Text(
            'Thay vì hỏi\nsao không thử tìm đáp án?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFF1C1C3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _showSubscreen('rank'),
              child: const Text(
                'Đấu hạng',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFF1C1C3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _showSubscreen('practice'),
              child: const Text(
                'Luyện tập',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    return Center(child: content);
  }
}
