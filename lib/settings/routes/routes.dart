import 'package:flutter/material.dart';
import 'package:who_is_liar/view/menu/menu_screen.dart';
import 'package:who_is_liar/view/start/start_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const MenuScreen(),
      '/start': (context) => const StartScreen(),
      // '/settings': (context) => const SettingsScreen(),
    };
  }
}
