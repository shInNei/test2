import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/socket_service.dart';
import 'package:provider/provider.dart';
import './data/data.dart';
import './models/room.dart';
import 'room.dart';
import 'home_rank.dart';

class LobbyScreen extends StatefulWidget {
  final bool autoCreate;
  const LobbyScreen({super.key, this.autoCreate = false});
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  String _currentSubscreen = 'lobby';
  late SocketRomService socketService;

  void _showSubscreen(String screen) {
    setState(() {
      _currentSubscreen = screen;
    });
  }
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    socketService = Provider.of<SocketRomService>(context, listen: false);
    // Gửi yêu cầu lấy danh sách phòng
    socketService.setupListeners(onRoomCreated:onRoomCreated, onRoomUpdate: onRoomUpdate, onRoomList: onRoomList);
  }
  void onRoomCreated(data) {
    Room currentRoom = Room.fromJson(data);
    print('data: ${currentRoom.status}');
    if (currentRoom.status == true) {
      print('✅ Phòng ${currentRoom.host.name} đã được tạo (is ${currentRoom.status}) : ${currentRoom.id}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoomScreen(room: currentRoom),
        ),
      ).then((_) {
        // Reload danh sách phòng khi quay lại từ RoomScreen
        if (mounted) socketService.getRooms(); // Reload khi quay lại

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo phòng thất bại')),
      );
    }
  }
  void onRoomUpdate(data)  {
    print('onRoomUpdate');
    final updatedRoom = data;

    print('onRoomUpdate: $data');
    setState(() {
      final index = rooms.indexWhere((r) => r.id == updatedRoom.id);
      if (index != -1) {
        rooms[index] = updatedRoom;
      }
    });
  }

  void onRoomList(data)  {
    print('📤 onRoomList update');
    if (!mounted) return; // Không làm gì nếu widget đã bị dispose

    setState(() {
      rooms = List<Room>.from(data.map((r) => Room.fromJson(r)));
    });
  }
  void _createRoom() async {
    final currentUser = await AuthService.getUser();
    final user = {
      "id": currentUser?['id'],
      "name": currentUser?['name'],
      "level": currentUser?['level'],
      "rank": currentUser?['rank'],
      "rankPoint": currentUser?['rankPoint'],
      "elo": currentUser?['elo'],
      "avatarPath": currentUser?['avatarPath'],
      "score": currentUser?['score'],
    };
    String id = '${currentUser?['id']}.${DateTime
        .now()
        .millisecondsSinceEpoch}';
    final host = Player.fromJson(user);
    socketService.createRoom(id, host);
  }

  void _enterByCode() {
    showDialog(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Nhập mã phòng'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(hintText: 'ID phòng'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = ctrl.text.trim();
                final found = rooms.firstWhere(
                  (r) => r.id == code,
                  orElse: () => Room(id: '', host: currentUser),
                );
                Navigator.pop(ctx);
                if (found.id.isNotEmpty) {
                  // giả lập join
                  final joined = Room(
                    id: found.id,
                    host: found.host,
                    opponent: currentUser,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RoomScreen(room: joined)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không tìm thấy phòng')),
                  );
                }
              },
              child: const Text('Vào'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // scaffold sẽ tạo sẵn Material cho toàn screen
      backgroundColor: Colors.white,
      // nội dung chính
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3E7FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Hàng tiêu đề + count + nút thoát
                Row(
                  children: [
                    const Text(
                      'Sảnh chờ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${rooms.length}/200',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    // nút thoát
                    IconButton(
                      icon: const Icon(Icons.close, size: 32),
                      tooltip: 'Đóng sảnh chờ',
                      onPressed: () => _showSubscreen('ranked'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // List phòng
                Expanded(
                  child: ListView.separated(
                    itemCount: rooms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final r = rooms[i];
                      return InkWell(
                        onTap: () async {
                          if (r.opponent == null) {
                            final currentUser = await AuthService.getUser();
                            final player = Player.fromJson(currentUser!);

                            socketService.joinRoomAndWait(
                              roomId: r.id,
                              player: player,
                              context: context,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Phòng đã đầy'),
                                content: const Text('Phòng này đã có đủ người chơi.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      r.opponent == null
                                          ? Colors.green
                                          : Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(r.id, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // Buttons tạo/nhập phòng
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _createRoom,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF1C1C3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Ensure text color is white
                          ),
                        ),
                        child: const Text(
                          'Tạo phòng',
                          style: TextStyle(
                            color: Colors.white,
                          ), // Explicitly set text color
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ), // Increased spacing to match the screenshot
                    OutlinedButton(
                      onPressed: _enterByCode,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ), // Add border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors
                                  .black, // Ensure text color contrasts with background
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black, // Icon color to match text
                            size: 24,
                          ),
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Nhập mã',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketService = Provider.of<SocketRomService>(context, listen: false);
    if (widget.autoCreate) {
      // chờ build xong mới push RoomScreen
      _createRoom();
    }
    // ✅ Gọi lại getRooms là đủ
    socketService.getRooms();
  }

  @override
  void dispose() {
    print('❌lobby  removeListeners');
    socketService.removeListeners(); // bạn cần định nghĩa hàm này
    super.dispose();
  }
}
