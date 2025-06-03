import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login/login.dart';
import 'layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/welcome.png',
      'title': 'Chào Mừng Người Chơi',
      'description':
          'Rèn luyện trí não, thử thách bạn bè và chinh phục mọi câu đố.',
      'buttonText': 'Tiếp Theo',
    },
    {
      'image': 'assets/images/howto.png', // Replace with your image path
      'title': 'Cách Chơi',
      'description':
          'Đấu trí mọi lúc, mọi nơi. Trả lời nhanh các câu đố IQ, tích điểm và leo lên bảng xếp hạng.',
      'buttonText': 'Tiếp Theo',
    },
    {
      'image': 'assets/images/connect.png',
      'title': 'Kết Nối Bạn Bè',
      'description':
          'Mời bạn bè tham gia, so tài trí tuệ và xem ai là người giỏi nhất!',
      'buttonText': 'Bắt Đầu',
    },
  ];

  void _nextPage() async {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Go to home or main screen
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: onboardingData.length,
        itemBuilder:
            (context, index) => OnboardingPage(
              image: onboardingData[index]['image']!,
              title: onboardingData[index]['title']!,
              description: onboardingData[index]['description']!,
              buttonText: onboardingData[index]['buttonText']!,
              onPressed: _nextPage,
              isLast: index == onboardingData.length - 1,
              currentPage: _currentPage,
              totalPages: onboardingData.length,
            ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description, buttonText;
  final VoidCallback onPressed;
  final bool isLast;
  final int currentPage, totalPages;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    required this.isLast,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(image, height: 220),
                  SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 12 : 8,
                        height: currentPage == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color:
                              currentPage == index
                                  ? Color(0xFF87B8B5)
                                  : Color(0xFFADD2CF),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Container(
              width: 160,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
