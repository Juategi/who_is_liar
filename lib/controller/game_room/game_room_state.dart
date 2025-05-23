import 'package:who_is_liar/controller/game_room/game_room.dart';

abstract class GameRoomState {
  const GameRoomState();
}

class GameRoomLoading extends GameRoomState {}

class GameRoomLoaded extends GameRoomState {
  final String code;
  final GameRoom? gameRoom;
  const GameRoomLoaded({
    required this.code,
    required this.gameRoom,
  });
}

class GameRoomError extends GameRoomState {
  final String message;

  const GameRoomError({required this.message});
}
