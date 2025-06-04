import 'package:who_is_liar/controller/game_room/game_room.dart';

abstract class GameRoomState {
  const GameRoomState();
}

class GameRoomLoading extends GameRoomState {}

class GameRoomError extends GameRoomState {
  final String message;

  const GameRoomError({required this.message});
}

abstract class RoomLoaded extends GameRoomState {
  final String code;
  final GameRoom? gameRoom;

  const RoomLoaded({
    required this.code,
    required this.gameRoom,
  });
}

class WaitingRoomLoaded extends RoomLoaded {
  WaitingRoomLoaded({required super.code, required super.gameRoom});
}

class QuestionGameLoaded extends RoomLoaded {
  QuestionGameLoaded({required super.code, required super.gameRoom});
}

class QuestionGameAnswerSent extends RoomLoaded {
  QuestionGameAnswerSent({required super.code, required super.gameRoom});
}

class ShowAnswers extends RoomLoaded {
  ShowAnswers({required super.code, required super.gameRoom});
}
