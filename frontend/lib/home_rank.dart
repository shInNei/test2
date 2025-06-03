import 'package:flutter/material.dart';
import 'package:frontend/socket_service.dart';
import 'package:provider/provider.dart';
import 'models/room.dart';
import 'ranked.dart';
import 'lobby.dart';
import 'data/data.dart';
import 'room.dart';
import 'findmatch.dart';

class HomeRankScreen extends StatefulWidget  {
  final VoidCallback onShowRanked;

  const HomeRankScreen({super.key, required this.onShowRanked});

  @override
  State<HomeRankScreen> createState() => _HomeRankScreen();
}

class _HomeRankScreen extends State<HomeRankScreen> {
  late SocketRomService socketService;
  late VoidCallback onShowRanked;
  @override
  void initState() {
    super.initState();
    onShowRanked = widget.onShowRanked;
    socketService = Provider.of<SocketRomService>(context, listen: false);
    socketService.connect(
      onConnected: () {
        print('🟢 Socket ready! You can safely call actions now.');
      },
      onRoomUpdate:(data) => {},
      onStartGame: (data) => {},
      onRoomDestroyed: (data) => {},
      onRoomCreated: (data) {},
    );
    socketService.setupListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketService = Provider.of<SocketRomService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Đấu Xếp Hạng',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/logo_2.png', height: 150),
              const SizedBox(height: 100),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LobbyScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Tham gia phòng',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FindMatchScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    'Tìm Trận',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LobbyScreen(autoCreate: true),
                      ),
                    );
                  },

                  child: const Text(
                    'Tạo phòng',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 80, // lowered from 40
          right: 16,
          child: GestureDetector(
            onTap: onShowRanked,
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Bảng Xếp Hạng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('❌home rank  removeListeners');
    socketService.removeListeners(); // bạn cần định nghĩa hàm này
    super.dispose();
  }

}




