class Player {
  final int id;
  final String name;
  final String email;
  final String avatarUrl;
  final int elo;
  final int exp;
  final int totalMatches;
  final int wins;
  final int losses;

  Player({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.elo,
    required this.exp,
    required this.totalMatches,
    required this.wins,
    required this.losses,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      elo: json['elo'] ?? 0,
      exp: json['exp'] ?? 0,
      totalMatches: json['total_matches'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'elo': elo,
      'exp': exp,
      'total_matches': totalMatches,
      'wins': wins,
      'losses': losses,
    };
  }
}
