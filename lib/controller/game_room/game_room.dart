class GameRoom {
  int createdAt;
  String code;
  Question? currentQuestion;
  List<Player> players = [];
  List<Question> questionsAnswered = [];
  String? impostor;

  GameRoom({
    required this.createdAt,
    required this.code,
    required this.players,
    this.currentQuestion,
    this.questionsAnswered = const [],
    required this.impostor,
  });

  GameRoom copyWith({
    int? createdAt,
    String? code,
    Question? currentQuestion,
    List<Player>? players,
    List<Question>? questionsAnswered,
    String? impostor,
  }) {
    return GameRoom(
      createdAt: createdAt ?? this.createdAt,
      code: code ?? this.code,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      players: players ?? List<Player>.from(this.players),
      questionsAnswered:
          questionsAnswered ?? List<Question>.from(this.questionsAnswered),
      impostor: impostor ?? this.impostor,
    );
  }
}

class Player {
  String name;
  bool isHost;
  bool isReady = false;
  String? answer;
  String? vote;

  Player({
    required this.name,
    this.isHost = false,
    this.isReady = false,
    this.answer,
    this.vote,
  });

  @override
  String toString() {
    return 'Player{name: $name, isHost: $isHost}';
  }
}

class Question {
  int id;
  String qt;
  String qf;

  Question({
    required this.id,
    required this.qt,
    required this.qf,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      qt: json['qt'] as String,
      qf: json['qf'] as String,
    );
  }
}
