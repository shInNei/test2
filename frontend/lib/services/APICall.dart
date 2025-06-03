import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart'; 
import '../models/category.dart';
import '../models/question.dart'; 

class ApiService {
  final String baseUrl;
  final String? token;

  ApiService({required this.baseUrl, required this.token});

  Future<Player> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/users/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Player.fromJson(data);
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  // Add other API methods here (e.g., updateProfile, fetchLeaderboard, etc.)
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );

    print('❌ Register response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      // Trả về JWT token
      final data = jsonDecode(response.body);
      return data; 
    } else if (response.statusCode == 409) {
      throw Exception("Email đã được sử dụng");
    } else {
      throw Exception("Đăng ký thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('🔐 Login response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data; 
    } else if (response.statusCode == 401) {
      throw Exception("Sai email hoặc mật khẩu");
    } else {
      throw Exception("Đăng nhập thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('📦 Categories response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<Question>> getQuestions({
    required String category,
    required int total,
  }) async {
    final url = Uri.parse('$baseUrl/gemini/getQuestion');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'category': category,
        'total': total,
      }),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<Player>> fetchLeaderboard() async {
    final url = Uri.parse('$baseUrl/leaderboard');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🏆 Leaderboard response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leaderboard: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<void> updateAfterMatch({
    required String userId,
    required int eloChange,
    required int expGain,
    required bool isWin,
  }) async {
    final url = Uri.parse('$baseUrl/users/$userId/update-after-match');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'eloChange': eloChange,
        'expGain': expGain,
        'isWin': isWin,
      }),
    );

    print('🎮 Update After Match response: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Cập nhật sau trận đấu thất bại: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<void> changeName(String newName) async {
    final url = Uri.parse('$baseUrl/users/me/change-name');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'newName': newName,
      }),
    );

    print('✏️ Change Name response: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Đổi tên thất bại: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/users/me/change-password');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    print('🔒 Change Password response: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      // ✅ Thử parse body để lấy lỗi cụ thể từ server
      String errorMessage = 'Đổi mật khẩu thất bại';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'];
        }
      } catch (_) {
        // Nếu parse lỗi, dùng body raw luôn
        errorMessage = response.body;
      }

      throw Exception(errorMessage);
      }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    print('📧 Forgot Password response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      // OTP sent successfully
      return;
    } else if (response.statusCode == 400) {
      throw Exception("Người dùng Google không dùng mật khẩu");
    } else {
      throw Exception("Yêu cầu đặt lại mật khẩu thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }


  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    print('🔁 Reset Password response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      // Password changed successfully
      return;
    } else if (response.statusCode == 400) {
      throw Exception("Thiếu thông tin hoặc OTP không hợp lệ");
    } else {
      throw Exception("Đặt lại mật khẩu thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<int> getMyRank() async {
    final url = Uri.parse('$baseUrl/leaderboard/rank');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('📊 Get My Rank response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rank_index'];
    } else {
      throw Exception('Không thể lấy hạng của người dùng: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
