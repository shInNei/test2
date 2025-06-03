import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'data/data.dart';
import 'layout.dart';

class FindMatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: currentUser.name,
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[100]),
      home: CreatingMatchPage(),
    );
  }
}

// Page 1: Không tìm thấy trận đấu
class NoMatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            GradientTitle(text: currentUser.name),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  currentUser.avatarUrl,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () async {
                  final bool? shouldContinue = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('Tiếp tục tìm kiếm?'),
                        content: Text(
                          'Bạn có muốn tiếp tục tìm kiếm trận đấu?',
                        ),
                        actions: [
                          TextButton(
                            onPressed:
                                () => Navigator.of(dialogContext).pop(true),
                            child: Text('Có'),
                          ),
                          TextButton(
                            onPressed:
                                () => Navigator.of(dialogContext).pop(false),
                            child: Text('Không'),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldContinue == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CreatingMatchPage()),
                    );
                  } else if (shouldContinue == false) {
                    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPageLayout()),
        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 4,
                ),
                child: Text(
                  'Không Tìm Được Trận\nQuay Lại Sảnh Chờ...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CreatingMatchPage extends StatefulWidget {
  @override
  _CreatingMatchPageState createState() => _CreatingMatchPageState();
}

class _CreatingMatchPageState extends State<CreatingMatchPage> {
  @override
  void initState() {
    super.initState();
    // Chuyển về NoMatchPage sau 5 giây
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NoMatchPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            GradientTitle(text: currentUser.name),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  currentUser.avatarUrl,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 4,
                ),
                child: Text(
                  'Đang Tạo Trận Đấu\nVui Lòng Chờ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Gradient text for the title
class GradientTitle extends StatelessWidget {
  final String text;
  GradientTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => LinearGradient(
            colors: [Colors.cyan.shade100, Colors.orange.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
