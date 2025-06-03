import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/APICall.dart';
import 'constants.dart';

class EditPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String imagePath;

  const EditPasswordScreen({
    super.key,
    required this.onBack,
    required this.imagePath,
  });

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  bool isSaving = false;
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  String? currentPasswordError;

  final String hardcodedPassword = "password123"; // simulate stored password

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  void checkSignIn() async {
    if (!await AuthService.isLoggedIn()) {
      await AuthService.logout();
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }


  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');
    return regex.hasMatch(password);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _showDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _saveChanges() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (!_isValidPassword(newPassword)) {
      _showErrorDialog("Mật khẩu mới phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số.");
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog("Mật khẩu mới và nhập lại mật khẩu không khớp.");
      return;
    }

    checkSignIn();

    try {
      final apiService = ApiService(baseUrl: SERVER_URL, token: await AuthService.getToken());
      final response = await apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch(e) {
      _showErrorDialog(e.toString().replaceAll("Exception: ", ""));
      return;
    }

    setState(() {
      isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isSaving = false;
    });

    await _showDialog('Thành công', 'Cập nhật tên người dùng thành công');

    widget.onBack(); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 125,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: widget.imagePath.startsWith('http')
                          ? NetworkImage(widget.imagePath)
                          : AssetImage('assets/images/default_image.png') as ImageProvider,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: !showCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showCurrentPassword = !showCurrentPassword;
                        });
                      },
                    ),
                    errorText: currentPasswordError,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: newPasswordController,
                  obscureText: !showNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmNewPasswordController,
                  obscureText: !showConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Xác Nhận"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

