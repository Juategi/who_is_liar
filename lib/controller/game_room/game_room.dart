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
  bool isHost;

  Player({
    required this.name,
    this.isHost = false,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      isHost: json['isHost'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'Player{name: $name, isHost: $isHost}';
  }
}
