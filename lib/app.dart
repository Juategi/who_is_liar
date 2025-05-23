import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room_controller.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/settings/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameRoomController>(
      create: (_) => GameRoomController(GameRoomModel()),
      child: MaterialApp(
        title: 'Who is Liar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
