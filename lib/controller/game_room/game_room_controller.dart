import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/ad_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class GameRoomController extends Cubit<GameRoomState> {
  GameRoomController(this.gameRoomModel, this.nameModel, this.adController)
      : super(GameRoomLoading());

  final GameRoomModel gameRoomModel;
  final NameModel nameModel;
  final AdController adController;
  int numberOfQuestionsPlayed = 0;
  StreamSubscription<DatabaseEvent>? _subscription;
  String? playerVoted;

  Future<void> createRoom() async {
    final String code = await gameRoomModel.createRoom();
    _listenRoom(code);
  }

  Future<void> joinRoom(String code) async {
    try {
      final exists = await gameRoomModel.joinRoom(code);
      if (exists) {
        _listenRoom(code);
      } else {
        emit(GameRoomError(message: 'room_does_not_exist_or_is_full'.tr()));
      }
    } catch (e) {
      if (!isClosed) {
        emit(GameRoomError(message: 'failed_to_join_room'.tr(args: ['$e'])));
      }
    }
  }

  void _listenRoom(String code) {
    _subscription =
        gameRoomModel.listenRoom(code).listen((DatabaseEvent event) {
      try {
        final data = event.snapshot.value as Map?;
        final gameRoom = GameRoom.fromMap(data!, code);
        // Put the current player at the top of the list
        gameRoom.players.sort((a, b) => a.id == nameModel.getId()
            ? -1
            : b.id == nameModel.getId()
                ? 1
                : a.name.compareTo(b.name));

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
        if (!isClosed) {
          emit(GameRoomError(
              message: 'unexpected_error'.tr(args: [e.toString()])));
        }
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
          .firstWhereOrNull((player) => player.id == nameModel.getId());
    }
    return null;
  }

  String getImpostorName(GameRoom? gameRoom) {
    final state = this.state;
    if (gameRoom == null) {
      return '';
    }
    if (state is RoomLoaded) {
      return gameRoom.players
              .firstWhereOrNull((player) => player.id == gameRoom.impostor)
              ?.name ??
          '';
    }
    return '';
  }

  int getTotalVotes(GameRoom? gameRoom, String playerId) {
    final state = this.state;
    if (gameRoom == null) {
      return 0;
    }
    if (state is RoomLoaded) {
      return gameRoom.players.where((player) => player.vote == playerId).length;
    }
    return 0;
  }

  Future<void> loadNextQuestion(String code) async {
    try {
      // Load ad every 2 questions played
      if (numberOfQuestionsPlayed > 0 && numberOfQuestionsPlayed % 2 == 0) {
        await adController.loadAd();
      }
      await gameRoomModel.loadNextQuestion(code);
      playerVoted = null; // Reset playerVoted after loading next question
      numberOfQuestionsPlayed++;
    } catch (e) {
      if (!isClosed) {
        emit(GameRoomError(message: 'failed_to_start_game'.tr(args: ['$e'])));
      }
    }
  }

  Future<void> sendAnswer(String code, String answer) async {
    try {
      await gameRoomModel.sendAnswer(code, answer);
    } catch (e) {
      if (!isClosed) {
        emit(GameRoomError(message: 'failed_to_send_answer'.tr(args: ['$e'])));
      }
    }
  }

  Future<void> sendVote(String code, String playerId) async {
    try {
      await gameRoomModel.sendVote(code, playerId);
      playerVoted = playerId;
    } catch (e) {
      if (!isClosed) {
        emit(GameRoomError(message: 'failed_to_send_vote'.tr(args: ['$e'])));
      }
    }
  }

  Future<void> showAnswers(String code) async {
    try {
      await gameRoomModel.showAnswers(code);
    } catch (e) {
      if (!isClosed) {
        emit(GameRoomError(message: 'failed_to_show_answers'.tr(args: ['$e'])));
      }
    }
  }

  Future<void> dispose() async {
    String code = state is RoomLoaded ? (state as RoomLoaded).code : '';
    emit(GameRoomLoading()); // Reset state
    await _subscription?.cancel();
    await gameRoomModel.leaveGame(code);
    playerVoted = null; // Reset playerVoted on dispose
    _subscription = null; // Clear subscription
    super.close();
  }
}
