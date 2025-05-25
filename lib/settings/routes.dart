import 'package:flutter/material.dart';
import 'package:who_is_liar/view/join/join_room_screen.dart';
import 'package:who_is_liar/view/menu/menu_screen.dart';
import 'package:who_is_liar/view/game_room/game_room_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const MenuScreen(),
      '/start': (context) => const GameRoomScreen(),
      '/join': (context) => const JoinRoomScreen(),
    };
  }
}
