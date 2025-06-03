import 'player.dart';

// 3. Model Room, mỗi Room luôn có host, có thể có hoặc chưa có opponent
class Room {
  final String id;
  final Player host;
  final Player? opponent;
  final bool? status ;

  Room({required this.id, required this.host, this.opponent, this.status});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      status: json['status'],
      host: Player.fromJson(json['host']),
      opponent: json['opponent'] != null ? Player.fromJson(json['opponent']) : null,
    );
  }
}

