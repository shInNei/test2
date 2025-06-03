import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/APICall.dart';
import 'constants.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String username;
  final String email;
  final String imagePath;

  const EditProfileScreen({
    super.key,
    required this.onBack,
    required this.username,
    required this.email,
    required this.imagePath,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController usernameController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    checkSignIn();
    usernameController = TextEditingController(text: widget.username);
  }

  void checkSignIn() async {
    if (!await AuthService.isLoggedIn()) {
      await AuthService.logout();
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
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
    final updatedUsername = usernameController.text;

    if (updatedUsername.trim().isEmpty) {
      await _showDialog('Lỗi', 'Tên người dùng không được để trống');
      return;
    }

    setState(() {
      isSaving = true;
    });

    // Simulate API call
    checkSignIn();

    final apiService = ApiService(baseUrl: SERVER_URL, token: await AuthService.getToken());

    try {
      await apiService.changeName(
        updatedUsername
      );
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      await _showDialog('Lỗi', e.toString().replaceAll("Exception: ", ""));
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isSaving = false;
    });

    await _showDialog('Thành công', 'Cập nhật tên người dùng thành công');

    widget.onBack();
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
                    "Chỉnh sửa thông tin",
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
                    // Positioned(
                    //   bottom: 4,
                    //   right: 4,
                    //   child: CircleAvatar(
                    //     radius: 14,
                    //     backgroundColor: Colors.white,
                    //     child: IconButton(
                    //       padding: EdgeInsets.zero,
                    //       icon: const Icon(Icons.camera_alt,
                    //           size: 16, color: Colors.orange),
                    //       onPressed: () {
                    //         // TODO: Add image picking logic
                    //       },
                    //     ),
                    //   ),
                    // ),
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
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                    border: OutlineInputBorder(),
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
          )
        ],
      ),
    );
  }
}
