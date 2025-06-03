import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'data/data.dart';
import './models/player.dart';
import './models/room.dart';
import 'lobby.dart';
import 'pvp_match.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:frontend/socket_service.dart';

class RoomScreen extends StatefulWidget  {
  final Room room;

  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Room currentRoom;
  late SocketRomService socketService;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserIdAndSetup();();
    currentRoom = widget.room;
  }

  Future<void> _loadCurrentUserIdAndSetup() async {
    currentUserId = await AuthService.getUserId();
    currentRoom = widget.room;

    socketService.onRoomUpdateCallback = (room) {
      if (room.id != currentRoom.id) return; // Không phải phòng mình đang ở → bỏ qua

      final isStillInRoom =
          room.host.id == currentUserId || room.opponent?.id == currentUserId;

      if (!isStillInRoom) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bạn đã bị rời khỏi phòng')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LobbyScreen()),
          );
        }
        return;
      }

      setState(() {
        currentRoom = room;
      });
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketService = Provider.of<SocketRomService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final hasOpponent = currentRoom.opponent != null;
    final isHost = currentRoom.host.id == currentUserId;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop) return;
        final socketService = Provider.of<SocketRomService>(context, listen: false);
        socketService.leaveRoom(currentRoom.id, currentUserId??0);

      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3E7FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      const Text(
                        'Phòng chờ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 66, 49, 5),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 32),
                        onPressed: () async {
                          final currentUserId = await AuthService.getUserId();
                          final socketService = Provider.of<SocketRomService>(context, listen: false);

                          if (currentUserId != null) {
                            socketService.leaveRoom(currentRoom.id, currentUserId);
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ID: ${currentRoom.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Host card
                  PlayerCard(player: currentRoom.host),

                  const SizedBox(height: 24),
                  // Opponent or placeholder
                  if (hasOpponent)
                    Stack(
                      children: [
                        PlayerCard(player: currentRoom.opponent!),
                        if (isHost)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () async {
                                // Host removes opponent (update room in the list)
                                final currentUserId = await AuthService.getUserId();
                                final socketService = Provider.of<SocketRomService>(context, listen: false);

                                if (currentUserId != null) {
                                  socketService.leaveRoom(currentRoom.id, currentRoom.opponent?.id ?? 0);
                                }

                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 12,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    PlaceholderCard(),

                  const Spacer(),

                  // Button dưới cùng
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (hasOpponent && isHost)
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PvPMatchScreen(
                              player1: currentRoom.host,
                              player2: currentRoom.opponent!,
                            ),
                          ),
                        );
                      }
                          : null, // ❌ Vô hiệu hóa nếu không phải host hoặc chưa có đối thủ
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasOpponent
                            ? (isHost ? Colors.black : Colors.blueGrey)
                            : Colors.blueGrey,
                      ),
                      child: Text(
                        hasOpponent
                            ? (isHost ? '⚔️ Bắt đầu' : 'Chờ chủ phòng bắt đầu')
                            : 'Đang chờ đối thủ...',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/// Widget dùng chung để render 1 Player card
class PlayerCard extends StatelessWidget {
  final Player player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(player.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Căn giữa theo chiều ngang
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level ${player.exp}', // Ở đây có thể là level 
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.email, // cho nay la rank
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ELO ${player.elo.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder khi chưa có opponent
class PlaceholderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greyBar(width: 120),
                const SizedBox(height: 8),
                greyBar(width: 180),
                const SizedBox(height: 8),
                greyBar(width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget greyBar({required double width}) =>
      Container(width: width, height: 16, color: Colors.grey.shade300);
}
