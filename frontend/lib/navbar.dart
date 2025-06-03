import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'layout.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        backgroundColor: const Color(0xFF1C1C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class ConvexNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ConvexNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.reactCircle,
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      color: const Color(0xFFB0BEC5), // Light blue-gray for inactive icons
      activeColor: const Color(0xFF42A5F5), // Softer blue for active tab/icon
      height: 50,
      curveSize: 60,
      top: -15,
      initialActiveIndex: currentIndex,
      onTap: onTap,
      items: const [
        TabItem(
          icon: Icon(Icons.home, size: 24),
          activeIcon: Icon(Icons.home, size: 24),
          title: '',
        ),
        TabItem(
          icon: Icon(Icons.notifications, size: 24),
          activeIcon: Icon(Icons.notifications, size: 24),
          title: '',
        ),
        // TabItem(
        //   icon: Icon(Icons.card_giftcard, size: 24),
        //   activeIcon: Icon(Icons.card_giftcard, size: 24),
        //   title: '',
        // ),
        TabItem(
          icon: Icon(Icons.person, size: 24),
          activeIcon: Icon(Icons.person, size: 24),
          title: '',
        ),
      ],
    );
  }
}
