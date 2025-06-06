import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/utils/code_utils.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class GameRoomModel {
  FirebaseDatabase database;
  final NameModel nameModel = GetIt.instance.get<NameModel>();
  List<Question> questions = [];

  GameRoomModel(this.database) {
    _getQuestionsFromFile();
  }

  Future<String> createRoom() async {
    final String code = CodeUtils.generateRandomId(5);
    final String id = nameModel.getId();
    await database.ref('nodes/$code').set({
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    database.ref('nodes/$code/players/$id').set({
      'name': nameModel.getName(),
      'isHost': true,
      'id': id,
    });
    return code;
  }

  Future<bool> joinRoom(String code) async {
    final String id = nameModel.getId();
    final DatabaseReference roomRef = database.ref('nodes/$code');
    final DatabaseEvent roomEvent = await roomRef.once();
    if (roomEvent.snapshot.value == null) {
      return false;
    }
    final DatabaseReference playersRef = database.ref('nodes/$code/players');
    final DatabaseEvent event = await playersRef.once();
    final players = event.snapshot.value as Map?;
    final int numberOfPlayers = players?.length ?? 0;
    if (numberOfPlayers >= 8) {
      throw Exception('Room is full');
    } else {
      database.ref('nodes/$code/players/$id').update({
        'name': nameModel.getName(),
        'isHost': false,
        'id': id,
      });
    }
    return true;
  }

  Stream<DatabaseEvent> listenRoom(String code) {
    Stream<DatabaseEvent> stream = database.ref('nodes/$code').onValue;
    return stream;
  }

  Future<void> loadNextQuestion(String code) async {
    // Load questions from a local JSON file
    if (questions.isEmpty) {
      await _getQuestionsFromFile();
    }

    // Retrieve the current question from the database
    final DatabaseReference questionRef = database.ref('nodes/$code');
    final DatabaseEvent event = await questionRef.once();
    final gameRoom = event.snapshot.value as Map?;
    final List<int> questionsAnswered =
        (gameRoom?['questionsAnswered'] as List<dynamic>? ?? [])
            .map((e) => e as int)
            .toList();

    // Otherwise, pick a new random question and update the database
    int randomIndex;
    do {
      randomIndex = math.Random().nextInt(questions.length);
    } while (questionsAnswered.contains(randomIndex));

    // If all questions have been answered, reset the list
    if (questionsAnswered.length == questions.length) {
      questionsAnswered.clear();
    }

    // Pick a random impostor from players
    final players = (gameRoom?['players'] as Map?)?.values.toList() ?? [];
    final impostorIndex = math.Random().nextInt(players.length);
    final impostor = players[impostorIndex]['id'];

    // Update the database with the new current question and answered questions
    final Question nextQuestion = questions[randomIndex];
    questionsAnswered.add(randomIndex);
    await questionRef.update({
      'currentQuestion': {
        'id': nextQuestion.id,
        'originalQuestion': nextQuestion.originalQuestion,
        'impostorQuestion': nextQuestion.impostorQuestion,
      },
      'questionsAnswered': questionsAnswered,
      'impostor': impostor,
      'show': false,
    });

    //For each player, reset their answer
    final DatabaseReference playersRef = database.ref('nodes/$code/players');
    final DatabaseEvent playersEvent = await playersRef.once();
    final playersData = playersEvent.snapshot.value as Map?;
    if (playersData != null) {
      for (final playerId in playersData.keys) {
        await database.ref('nodes/$code/players/$playerId').update({
          'answer': '',
          'vote': '',
        });
      }
    }
  }

  Future<void> _getQuestionsFromFile() async {
    final fileId = '1z1c1B60OSsdI2N0K9ZNnvR_XpWl9U82p';
    final url = 'https://drive.google.com/uc?export=download&id=$fileId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final content = response.body;
      // Decode JSON
      final List<dynamic> data = json.decode(content);
      // Convert to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> listOfMaps =
          data.cast<Map<String, dynamic>>();
      // Decode possible malformed UTF-8 strings
      final formattedList = listOfMaps.map((map) {
        return map.map((key, value) {
          if (value is String) {
            // Decode string to fix malformed UTF-8
            final decoded = utf8.decode(latin1.encode(value));
            return MapEntry(key, decoded);
          }
          return MapEntry(key, value);
        });
      }).toList();
      final List<QuestionDTO> questions =
          formattedList.map((data) => QuestionDTO.fromJson(data)).toList();
      this.questions = questions.map((dto) => Question.fromDTO(dto)).toList();
    }
  }

  Future<void> sendAnswer(String code, String answer) async {
    final DatabaseReference answerRef =
        database.ref('nodes/$code/players/${nameModel.getId()}');
    await answerRef.update({
      'answer': answer,
    });
  }

  Future<void> showAnswers(
    String code,
  ) async {
    final DatabaseReference questionRef = database.ref('nodes/$code');
    await questionRef.update({
      'show': true,
    });
  }

  Future<void> sendVote(String code, String playerId) async {
    final DatabaseReference answerRef =
        database.ref('nodes/$code/players/${nameModel.getId()}');
    await answerRef.update({
      'vote': playerId,
    });
  }

  Future<void> leaveGame(String code) async {
    final String id = nameModel.getId();
    await database.ref('nodes/$code/players/$id').remove();
    if (await _isLastPlayer(code)) {
      await database.ref('nodes/$code').remove();
    }
  }

  Future<bool> _isLastPlayer(String code) async {
    final DatabaseReference playersRef = database.ref('nodes/$code/players');
    final DatabaseEvent event = await playersRef.once();
    final players = event.snapshot.value as Map?;
    return players == null || players.isEmpty;
  }
}
