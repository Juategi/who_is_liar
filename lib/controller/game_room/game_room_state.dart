import 'package:who_is_liar/controller/game_room/game_room.dart';

abstract class GameRoomState {
  const GameRoomState();
}

class GameRoomLoading extends GameRoomState {}

class GameRoomError extends GameRoomState {
  final String message;

  const GameRoomError({required this.message});
}

class WaitingRoomLoaded extends GameRoomState {
  final String code;
  final GameRoom? gameRoom;
  const WaitingRoomLoaded({
    required this.code,
    required this.gameRoom,
  });
}

class QuestionGameLoaded extends GameRoomState {
  final String code;
  final GameRoom? gameRoom;
  const QuestionGameLoaded({
    required this.code,
    required this.gameRoom,
  });
}
