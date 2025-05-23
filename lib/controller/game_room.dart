class GameRoom {
  int createdAt;
  String code;
  bool status;
  List<Player> players = [];

  GameRoom({
    required this.createdAt,
    required this.code,
    required this.status,
    required this.players,
  });
}

class Player {
  String name;

  Player({
    required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Player{name: $name}';
  }
}
