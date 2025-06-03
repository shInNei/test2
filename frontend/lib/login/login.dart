import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/services/APICall.dart';
import '../services/auth_service.dart';
import 'register.dart';
import '../layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart'; // 🔁 thay đúng đường dẫn
import '../constants.dart';
import 'google_auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'forgetpass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _errorText;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    }
    
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }


  void _login() async {
    // Check if fields are empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorText = 'Tên Đăng Nhập hoặc Mật Khẩu không được để trống';
      });
      return;
    }

    final email = _emailController.text.trim();
    if (!isValidEmail(email)){
      setState(() {
        _errorText = 'Email không hợp lệ';
      });
      return;
    }

    ApiService apiService = ApiService(baseUrl: SERVER_URL, token: null);

    try {
      final data = await apiService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Optionally, you can use the `data` here
      print('🔐 Login successful: $data');
      
      final token = data['accessToken'];
      final user = data['user'];
      await AuthService.saveLoginData(token, user, false);
      if (user != null) {
        print('✅ Token saved to local storage');
        final user = await AuthService.getUser();
        print('user: ${user}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPageLayout()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại')),
          );
        }  
    } catch (e) {
      setState(() {
        _errorText = e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Lỗi không xác định';
      });
      return;
    }

    // // Check credentials against fake user data
    // bool isAuthenticated = false;
    // int? playerIndex;
    // for (var user in userData) {
    //   if (user["username"] == _emailController.text &&
    //       user["password"] == _passwordController.text) {
    //     isAuthenticated = true;
    //     playerIndex = user["playerIndex"];
    //     break;
    //   }
    // }

    // if (isAuthenticated && playerIndex != null) {
    //   setState(() {
    //     _errorText = null;
    //     currentUser = players[playerIndex];
    //   });
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const MainPageLayout()),
    //   );
    // } else {
    //   setState(() {
    //     _errorText = 'Tên Đăng Nhập hoặc Mật Khẩu không đúng. Vui lòng thử lại';
    //   });
    // }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Đăng nhập',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng nhập tên đăng nhập và mật khẩu của bạn',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '@gmail.com',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Điều hướng đến trang "Quên mật khẩu"
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF132958),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Hoặc'),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  final response = await GoogleAuthService().signInAndSendToBackend();
                  final token = response?['accessToken'];
                  final user = response?['user'];

                  await AuthService.saveLoginData(token, user, true);
                  if (user != null) {
                    print('✅ Token saved to local storage');
                    final user = await AuthService.getUser();
                    print('user: ${user}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPageLayout()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đăng nhập thất bại')),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/images/google.png',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Tiếp tục với tài khoản Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // const SizedBox(height: 16),
              // OutlinedButton.icon(
              //   onPressed: () {
              //     // TODO: Đăng nhập với Facebook
              //   },
              //   icon: const Icon(Icons.facebook, color: Colors.blue),
              //   label: const Text('Tiếp tục với tài khoản Facebook'),
              //   style: OutlinedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 32),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Không có tài khoản?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
