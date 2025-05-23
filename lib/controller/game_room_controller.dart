import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room.dart';
import 'package:who_is_liar/controller/game_room_state.dart';
import 'package:who_is_liar/model/game_room_model.dart';

class GameRoomController extends Cubit<GameRoomState> {
  GameRoomController(this.gameRoomModel) : super(GameRoomLoading());

  final GameRoomModel gameRoomModel;
  StreamSubscription<DatabaseEvent>? _subscription;

  Future<void> loadGameRoom() async {
    final String code = await gameRoomModel.createRoom();
    final Stream<DatabaseEvent> playersStream = gameRoomModel.listenRoom(code);
    _subscription = playersStream.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data == null) {
        emit(GameRoomError(message: 'No data found'));
        return;
      }
      final gameRoom = GameRoom(
        code: code,
        status: data['status'] as bool,
        createdAt: data['createdAt'] as int,
        players: data['players'] != null
            ? (data['players'] as Map).entries.map((e) {
                return Player(
                  name: e.value['name'],
                  isHost: e.value['isHost'] as bool,
                );
              }).toList()
            : [],
      );
      emit(GameRoomLoaded(code: code, gameRoom: gameRoom));
    });
  }

  void dispose() {
    _subscription?.cancel();
    super.close();
  }
}
