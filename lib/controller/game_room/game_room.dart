class GameRoom {
  int createdAt;
  String code;
  Question? currentQuestion;
  List<Player> players = [];
  List<Question> questionsAnswered = [];
  String? impostor;
  bool? show;

  GameRoom({
    required this.createdAt,
    required this.code,
    required this.players,
    this.currentQuestion,
    this.questionsAnswered = const [],
    required this.impostor,
    this.show = false,
  });

  GameRoom copyWith({
    int? createdAt,
    String? code,
    Question? currentQuestion,
    List<Player>? players,
    List<Question>? questionsAnswered,
    String? impostor,
    bool? show,
  }) {
    return GameRoom(
      createdAt: createdAt ?? this.createdAt,
      code: code ?? this.code,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      players: players ?? List<Player>.from(this.players),
      questionsAnswered:
          questionsAnswered ?? List<Question>.from(this.questionsAnswered),
      impostor: impostor ?? this.impostor,
      show: show ?? this.show,
    );
  }

  factory GameRoom.fromMap(Map<dynamic, dynamic> map, String code) {
    return GameRoom(
      code: code,
      createdAt: map['createdAt'] as int,
      impostor: map['impostor'] as String?,
      show: map['show'] as bool? ?? false,
      currentQuestion: map['currentQuestion'] != null
          ? Question(
              id: map['currentQuestion']['id'],
              originalQuestion: map['currentQuestion']['originalQuestion'],
              impostorQuestion: map['currentQuestion']['impostorQuestion'],
            )
          : null,
      players: map['players'] != null
          ? (map['players'] as Map).entries.map((e) {
              return Player(
                id: e.value['id'] as String,
                name: e.value['name'],
                isHost: e.value['isHost'] as bool? ?? false,
                answer: e.value['answer'] as String?,
              );
            }).toList()
          : [],
    );
  }
}

class Player {
  String name;
  bool isHost;
  bool isReady = false;
  String id;
  String? answer;
  String? vote;

  Player({
    required this.name,
    required this.id,
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
  String originalQuestion;
  String impostorQuestion;

  Question({
    required this.id,
    required this.originalQuestion,
    required this.impostorQuestion,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      originalQuestion: json['originalQuestion'] as String,
      impostorQuestion: json['impostorQuestion'] as String,
    );
  }
}
