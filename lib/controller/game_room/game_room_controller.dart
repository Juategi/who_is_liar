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
      final data = event.snapshot.value as Map?;
      try {
        final gameRoom = GameRoom(
          code: code,
          status: data!['status'] as bool,
          createdAt: data['createdAt'] as int,
          players: data['players'] != null
              ? (data['players'] as Map).entries.map((e) {
                  return Player(
                    name: e.value['name'],
                    isHost: e.value['isHost'] as bool? ?? false,
                  );
                }).toList()
              : [],
        );
        emit(GameRoomLoaded(code: code, gameRoom: gameRoom));
      } catch (e) {
        emit(GameRoomError(message: 'No data room found'));
        return;
      }
    });
  }

  bool isHost() {
    final state = this.state;
    if (state is GameRoomLoaded) {
      return state.gameRoom!.players
          .firstWhere((player) => player.name == nameModel.getName())
          .isHost;
    }
    return false;
  }

  void dispose() {
    _subscription?.cancel();
    super.close();
  }
}
