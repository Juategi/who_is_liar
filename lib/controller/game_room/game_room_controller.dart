import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
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
      try {
        final data = event.snapshot.value as Map?;
        final gameRoom = GameRoom.fromMap(data!, code);
        if (gameRoom.show == true) {
          emit(ShowAnswers(code: code, gameRoom: gameRoom));
          return;
        } else if (gameRoom.currentQuestion != null) {
          String? checkAnswer = getCurrentPlayer(gameRoom)!.answer;
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
    if (state is RoomLoaded) {
      return getCurrentPlayer(state.gameRoom!)!.isHost;
    }
    return false;
  }

  bool isImpostor() {
    final state = this.state;
    if (state is RoomLoaded) {
      return getCurrentPlayer(state.gameRoom!)!.id == state.gameRoom!.impostor;
    }
    return false;
  }

  Player? getCurrentPlayer(GameRoom? gameRoom) {
    final state = this.state;
    if (gameRoom == null) {
      return null;
    }
    if (state is RoomLoaded) {
      return gameRoom.players
          .firstWhere((player) => player.id == nameModel.getId());
    }
    return null;
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

  Future<void> showAnswers(String code) async {
    try {
      await gameRoomModel.showAnswers(code);
    } catch (e) {
      emit(GameRoomError(message: 'Failed to send answer: $e'));
    }
  }

  void dispose() {
    String code = state is RoomLoaded ? (state as RoomLoaded).code : '';
    _subscription?.cancel();
    gameRoomModel.leaveGame(code);
    super.close();
  }
}
