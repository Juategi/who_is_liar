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
  bool isReady;
  bool isHost;

  Player({
    required this.name,
    required this.isReady,
    required this.isHost,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      isReady: json['isReady'] as bool,
      isHost: json['isHost'] as bool,
    );
  }

  @override
  String toString() {
    return 'Player{name: $name, isReady: $isReady, isHost: $isHost}';
  }
}
