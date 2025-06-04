import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/utils/code_utils.dart';
import 'dart:math' as math;

class GameRoomModel {
  final database = FirebaseDatabase.instance;
  final NameModel nameModel = GetIt.instance.get<NameModel>();

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

  Future<void> joinRoom(String code) async {
    final String id = nameModel.getId();
    database.ref('nodes/$code/players/$id').set({
      'name': nameModel.getName(),
      'isHost': false,
      'id': id,
    });
  }

  Stream<DatabaseEvent> listenRoom(String code) {
    Stream<DatabaseEvent> stream = database.ref('nodes/$code').onValue;
    return stream;
  }

  Future<void> loadNextQuestion(String code) async {
    // Load questions from a local JSON file
    final String jsonString =
        await rootBundle.loadString('assets/questions/questions.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final List<Question> questions = jsonData
        .map((data) => Question.fromJson(data as Map<String, dynamic>))
        .toList();

    // Retrieve the current question from the database
    final DatabaseReference questionRef = database.ref('nodes/$code');
    final DatabaseEvent event = await questionRef.once();
    final gameRoom = event.snapshot.value as Map?;
    final questionsAnswered =
        (gameRoom?['questionsAnswered'] as List<int>?) ?? [];

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
        });
      }
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
