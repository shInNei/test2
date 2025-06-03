import 'package:flutter/material.dart';
import 'profile_edit.dart';
import 'changepass.dart';
import 'ranked.dart';
import 'login/login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'models/player.dart';
import 'services/APICall.dart';
import 'package:frontend/constants.dart';
import 'services/auth_service.dart';
import 'models/playerutils.dart';


class ProfileScreen extends StatefulWidget {
  final bool resetToMain;
  final VoidCallback? onResetComplete;

  const ProfileScreen({
    super.key,
    this.resetToMain = false,
    this.onResetComplete,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Player? profileData;
  bool isLoading = true;

  String _currentSubscreen = 'main'; // 'main', 'update', 'password'

  @override
  void initState() {
    super.initState();
    checkSignIn();
    fetchProfile(context);
  }

  void checkSignIn() async {
    if (!await AuthService.isLoggedIn()) {
      // If not logged in, redirect to login screen
      await AuthService.logout(); // Ensure user is logged out

      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetToMain && !oldWidget.resetToMain) {
      setState(() {
        _currentSubscreen = 'main';
      });

      // Notify parent that reset has completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onResetComplete?.call();
      });
    }
  }

  Future<void> fetchProfile(BuildContext context) async {


    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final currentUser = userProvider.currentUser;

    // if (currentUser == null) {
    //   throw Exception('No user is currently logged in');
    // }
    
    // print(currentUser.avatarPath);

    final api = ApiService(baseUrl: SERVER_URL, token: await AuthService.getToken());

    try {
      final user = await api.getCurrentUser();
      print(user);
      
      setState(() {
      profileData = user;
      isLoading = false;
      print('Profile data fetched successfully: $profileData');
    });
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
        profileData = null; // Handle error case
      });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
    }

    // await Future.delayed(const Duration(seconds: 2));
  }

  void _showSubscreen(String screen) {
    if (screen == 'main') {
      setState(() {
        isLoading = true;         // Show loading indicator
        _currentSubscreen = screen;
      });
      fetchProfile(context);       // Re-fetch data
    } else {
      setState(() {
        _currentSubscreen = screen;
      });
    }
  }

@override
Widget build(BuildContext context) {
  if (isLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  final data = profileData;
  
  
  // If subscreen is 'rank', return Scaffold without AppBar
  if (_currentSubscreen == 'rank') {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildSubscreen(data),
    );
  }

  // Otherwise, return Scaffold with AppBar
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      leading: _currentSubscreen != 'main'
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _showSubscreen('main');
              },
            )
          : null,
      title: const Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () {
            // Logout logic
            AuthService.logout();
            print("User logged out");
            Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal.withAlpha((0.7 * 255).toInt()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Đăng Xuất',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
    body: _buildSubscreen(data),
  );
}


  Widget _buildSubscreen(Player? data) {

    final currentPlayer = Player(
        id: data?.id ?? -1,
        name: data?.name ?? "Không xác định",
        email: data?.email ?? "Không xác định",
        avatarUrl: data?.avatarUrl ?? "",
        elo: data?.elo ?? 0,
        exp: data?.exp ?? 0,
        totalMatches: data?.totalMatches ?? 0,
        wins: data?.wins ?? 0,
        losses: data?.losses ?? 0,
      );

    final rank = PlayerUtils.getRankFromElo(currentPlayer.elo);

    if (_currentSubscreen == 'update') {
      return EditProfileScreen(
        onBack: () => _showSubscreen('main'),
        username: currentPlayer.name,
        email: currentPlayer.email,
        imagePath: currentPlayer.avatarUrl,
      );
    } else if (_currentSubscreen == 'password') {
        return EditPasswordScreen(
        onBack: () => _showSubscreen('main'),
        imagePath: currentPlayer.avatarUrl,
      );
    } else if (_currentSubscreen == 'rank') {
      return RankedScreen(
        onBack: () => _showSubscreen('main'),
      );
    }

    // Main profile screen
    return Column(
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
            Positioned(
              bottom: -50,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: currentPlayer.avatarUrl.isNotEmpty
                    ? NetworkImage(currentPlayer.avatarUrl)
                    : const AssetImage('assets/images/default_image.png') as ImageProvider,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          profileData!.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Level ${PlayerUtils.getLevelFromExp(currentPlayer.exp) + 1}',
          style: const TextStyle(fontSize: 18, color: Colors.orange),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _showSubscreen('rank');
              },
              icon: const Icon(Icons.leaderboard),
              label: const Text("Xếp hạng"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock),
              label: const Text("Thành tích"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            const Icon(Icons.school, size: 80, color: Colors.teal),
            Text(
              rank,
              style: TextStyle(fontSize: 20, color: PlayerUtils.getRankColor(rank)),
            ),
            // Text(
            //   "${data['points']} điểm / ${data['maxPoints']}",
            //   style: const TextStyle(fontSize: 14),
            // ),
            Text(
              "Elo ${profileData!.elo}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _showSubscreen('update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(300, 50),
          ),
          child: const Text("Thay Đổi Thông Tin"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async{

            if (await AuthService.isGoogleLogin()) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Không khả dụng"),
                  content: const Text("Chức năng đổi mật khẩu chỉ áp dụng cho tài khoản đăng ký thông thường."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            } else {
              _showSubscreen('password');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(300, 50),
          ),
          child: const Text("Đổi Mật Khẩu"),
        ),
      ],
    );
  }
}
