class GameRoom {
  int createdAt;
  String code;
  List<Player> players = [];

  GameRoom({
    required this.createdAt,
    required this.code,
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

  @override
  String toString() {
    return 'Player{name: $name, isHost: $isHost}';
  }
}
