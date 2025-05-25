import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'dart:math' as math;
import 'package:who_is_liar/model/name_model.dart';

class GameRoomModel {
  final database = FirebaseDatabase.instance;
  final NameModel nameModel = GetIt.instance.get<NameModel>();

  Future<String> createRoom() async {
    final String code = _randomCode();
    final String name = nameModel.getName();
    await database.ref('nodes/$code').set({
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    database.ref('nodes/$code/players/$name').set({
      'name': name,
      'isHost': true,
    });
    return code;
  }

  Future<void> joinRoom(String code) async {
    final String name = nameModel.getName();
    database.ref('nodes/$code/players/$name').set({
      'name': name,
      'isHost': false,
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

    // Update the database with the new current question and answered questions
    final Question nextQuestion = questions[randomIndex];
    questionsAnswered.add(randomIndex);
    await questionRef.update({
      'currentQuestion': {
        'id': nextQuestion.id,
        'qt': nextQuestion.qt,
        'qf': nextQuestion.qf,
      },
      'questionsAnswered': questionsAnswered,
    });
  }

  String _randomCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = StringBuffer();
    for (int i = 0; i < 5; i++) {
      random.write(
          characters[(characters.length * math.Random().nextDouble()).floor()]);
    }
    return random.toString();
  }
}
