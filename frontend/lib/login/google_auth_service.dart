import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/constants.dart';

class GoogleAuthService {
  final _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>?> signInAndSendToBackend() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      print('❌ idToken: ${idToken}');
      // Gửi token về backend
      final response = await http.post(
        Uri.parse('$SERVER_URL/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Auth success: $data');
        return data;
      } else {
        print('❌ Server error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Google Auth Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('✅ Google account signed out');
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }
}
