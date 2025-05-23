import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room_controller.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';

class Di {
  static void setup() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<NameModel>(NameModel());
    getIt.registerSingleton<GameRoomModel>(GameRoomModel());
    getIt.registerSingleton<GameRoomController>(
        GameRoomController(getIt<GameRoomModel>()));
  }
}
