import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../services/APICall.dart';
import '../services/auth_service.dart';
import '../constants.dart';
import '../layout.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Tạo một tài khoản để tiếp tục!"),
                  const SizedBox(height: 24),

                  // Tên tài khoản
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Tên tài khoản",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Tên tài khoản không được bỏ trống";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email không được bỏ trống";
                      } else if (!EmailValidator.validate(value.trim())) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mật khẩu không được bỏ trống";
                      } else if (value.length < 6) {
                        return "Mật khẩu phải có ít nhất 6 ký tự";
                      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$').hasMatch(value)) {
                        return "Mật khẩu phải chứa chữ hoa, chữ thường và số";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Xác nhận mật khẩu
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Xác nhận mật khẩu",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng xác nhận mật khẩu";
                      } else if (value != passwordController.text) {
                        return "Mật khẩu không khớp";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nút đăng ký
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async{
                        // TODO: Add registration logic here
                        if (_formKey.currentState!.validate()) {
                          // Perform registration
                          ApiService apiService = ApiService(baseUrl: SERVER_URL, token: null);

                          try {
                            final data = await apiService.register(
                              email: emailController.text.trim(),
                              name: usernameController.text.trim(),
                              password: passwordController.text,
                            );
                            print("Đăng ký thành công, token: $data");

                            // final token = data['accessToken'];
                            // final user = data['user'];
                            // await AuthService.saveLoginData(token, user);

                            // if (user != null) {
                            //   print('✅ Token saved to local storage');
                            //   final user = await AuthService.getUser();
                            //   print('user: ${user}');
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => const MainPageLayout()),
                            //   );
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Đăng nhập thất bại')),
                            //   );
                            // }      
                            //

                            if (!mounted) return;

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Thành công"),
                                content: const Text("Tài khoản đã được đăng ký!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                                      );
                                    },
                                    child: const Text("Đăng nhập"),
                                  ),
                                ],
                              ),
                            );
                          } 
                          catch (e) {
                            // Hiển thị thông báo lỗi
                            if (!mounted) return;
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Đăng ký thất bại"),
                                content: Text(e.toString().replaceAll("Exception: ", "")),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("Đóng"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      }, // gắn xử lý ở đây
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent, // fix ở đây
                        shadowColor: Colors.transparent,     // loại bỏ đổ bóng nếu cần
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B3B98), Color(0xFF5F27CD)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Đã có tài khoản?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Đã có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Đăng nhập"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}