import 'package:flutter/material.dart';
import 'services/APICall.dart';
import 'models/category.dart';
import 'constants.dart';
import 'services/auth_service.dart';
import 'practice_match_screen.dart';

class PracticeScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PracticeScreen({super.key, required this.onBack});

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    checkSignIn();
    _futureCategories = _loadCategories();
  }

  void checkSignIn() async {
        if (!await AuthService.isLoggedIn()) {
      // If not logged in, redirect to login screen
      await AuthService.logout(); // Ensure user is logged out

      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }


  Future<List<Category>> _loadCategories() async {
    final token = await AuthService.getToken();
    final apiService = ApiService(baseUrl: SERVER_URL, token: token);
    try {
      return await apiService.getCategories();
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories');
    }
  }

  IconData getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();

    if(lowerName.contains('toán')) return Icons.calculate;
    if (lowerName.contains('văn')) return Icons.menu_book;
    if (lowerName.contains('lý')) return Icons.science;
    if (lowerName.contains('hóa')) return Icons.science_outlined;
    if (lowerName.contains('sinh')) return Icons.biotech;
    if (lowerName.contains('địa')) return Icons.public;
    if (lowerName.contains('sử')) return Icons.history_edu;
    if (lowerName.contains('tiếng anh') || lowerName.contains('english')) return Icons.language;
    return Icons.category; // Default icon
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Các bộ câu hỏi'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
        ),
        body: FutureBuilder<List<Category>>(
          future: _futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              final categories = snapshot.data!;
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final icon = getCategoryIcon(category.name);
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(icon, size: 40, color: Colors.blue),
                      title: Text(
                        category.name,
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              category: category.name
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    }
}
