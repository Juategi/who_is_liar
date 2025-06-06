import 'dart:ui';

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
                vote: e.value['vote'] as String?,
              );
            }).toList()
          : [],
    );
  }
}

class Player {
  String name;
  bool isHost;
  String id;
  String? answer;
  String? vote;

  Player({
    required this.name,
    required this.id,
    this.isHost = false,
    this.answer,
    this.vote,
  });

  @override
  String toString() {
    return 'Player{name: $name, isHost: $isHost}';
  }
}

class QuestionDTO {
  int id;
  String originalQuestionES;
  String originalQuestionEN;
  String originalQuestionDE;
  String originalQuestionFR;
  String impostorQuestionES;
  String impostorQuestionEN;
  String impostorQuestionDE;
  String impostorQuestionFR;

  QuestionDTO({
    required this.id,
    required this.originalQuestionES,
    required this.originalQuestionEN,
    required this.originalQuestionDE,
    required this.originalQuestionFR,
    required this.impostorQuestionES,
    required this.impostorQuestionEN,
    required this.impostorQuestionDE,
    required this.impostorQuestionFR,
  });

  factory QuestionDTO.fromJson(Map<String, dynamic> json) {
    return QuestionDTO(
      id: json['id'] as int,
      originalQuestionES: json['originalQuestionES'] as String,
      originalQuestionEN: json['originalQuestionEN'] as String,
      originalQuestionDE: json['originalQuestionDE'] as String,
      originalQuestionFR: json['originalQuestionFR'] as String,
      impostorQuestionES: json['impostorQuestionES'] as String,
      impostorQuestionEN: json['impostorQuestionEN'] as String,
      impostorQuestionDE: json['impostorQuestionDE'] as String,
      impostorQuestionFR: json['impostorQuestionFR'] as String,
    );
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

  factory Question.fromDTO(QuestionDTO dto) {
    String locale = PlatformDispatcher.instance.locale.languageCode;
    String originalQuestion;
    String impostorQuestion;

    switch (locale) {
      case 'es':
        originalQuestion = dto.originalQuestionES;
        impostorQuestion = dto.impostorQuestionES;
        break;
      case 'de':
        originalQuestion = dto.originalQuestionDE;
        impostorQuestion = dto.impostorQuestionDE;
        break;
      case 'fr':
        originalQuestion = dto.originalQuestionFR;
        impostorQuestion = dto.impostorQuestionFR;
        break;
      default:
        originalQuestion = dto.originalQuestionEN;
        impostorQuestion = dto.impostorQuestionEN;
    }
    return Question(
      id: dto.id,
      originalQuestion: originalQuestion,
      impostorQuestion: impostorQuestion,
    );
  }
}
