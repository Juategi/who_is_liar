import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';

class GameRoomController extends Cubit<GameRoomState> {
  GameRoomController(this.gameRoomModel, this.nameModel)
      : super(GameRoomLoading());

  final GameRoomModel gameRoomModel;
  final NameModel nameModel;
  late BuildContext context;
  StreamSubscription<DatabaseEvent>? _subscription;

  Future<void> createRoom() async {
    final String code = await gameRoomModel.createRoom();
    _listenRoom(code);
  }

  Future<void> joinRoom(String code) async {
    try {
      await gameRoomModel.joinRoom(code);
      _listenRoom(code);
    } catch (e) {
      emit(GameRoomError(message: 'Failed to join room: $e'));
    }
  }

  void _listenRoom(String code) {
    _subscription =
        gameRoomModel.listenRoom(code).listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      try {
        final gameRoom = GameRoom(
          code: code,
          createdAt: data!['createdAt'] as int,
          impostor: data['impostor'] as String?,
          currentQuestion: data['currentQuestion'] != null
              ? Question(
                  id: data['currentQuestion']['id'],
                  qt: data['currentQuestion']['qt'],
                  qf: data['currentQuestion']['qf'],
                )
              : null,
          players: data['players'] != null
              ? (data['players'] as Map).entries.map((e) {
                  return Player(
                    id: e.value['id'] as String,
                    name: e.value['name'],
                    isHost: e.value['isHost'] as bool? ?? false,
                    answer: e.value['answer'] as String?,
                  );
                }).toList()
              : [],
        );
        if (gameRoom.currentQuestion != null) {
          String? checkAnswer = gameRoom.players
              .firstWhere((player) => player.id == nameModel.getId())
              .answer;
          if (checkAnswer != null && checkAnswer.isNotEmpty) {
            emit(
              QuestionGameAnswerSent(
                code: code,
                gameRoom: gameRoom,
              ),
            );
          } else {
            emit(QuestionGameLoaded(code: code, gameRoom: gameRoom));
          }
        } else {
          emit(WaitingRoomLoaded(code: code, gameRoom: gameRoom));
        }
      } catch (e) {
        emit(GameRoomError(message: 'No data room found'));
        return;
      }
    });
  }

  bool isHost() {
    final state = this.state;
    if (state is WaitingRoomLoaded) {
      return state.gameRoom!.players
          .firstWhere((player) => player.id == nameModel.getId())
          .isHost;
    }
    return false;
  }

  Future<void> loadNextQuestion(String code) async {
    try {
      await gameRoomModel.loadNextQuestion(code);
    } catch (e) {
      emit(GameRoomError(message: 'Failed to start game: $e'));
    }
  }

  Future<void> sendAnswer(String code, String answer) async {
    try {
      await gameRoomModel.sendAnswer(code, answer);
    } catch (e) {
      emit(GameRoomError(message: 'Failed to send answer: $e'));
    }
  }

  void dispose() {
    _subscription?.cancel();
    super.close();
  }
}
