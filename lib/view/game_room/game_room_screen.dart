import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/game_room/screens/question_game_screen.dart';
import 'package:who_is_liar/view/game_room/screens/waiting_room_screen.dart';
import 'package:who_is_liar/view/widgets/background.dart';

class GameRoomScreen extends StatefulWidget {
  const GameRoomScreen({super.key});

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  late GameRoomController _gameRoomController;
  @override
  void dispose() {
    // Dispose of the GameRoomController when the screen is disposed
    // This is important to prevent memory leaks
    _gameRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    _gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (args != null) {
        BlocProvider.of<GameRoomController>(context).joinRoom(args as String);
      } else {
        BlocProvider.of<GameRoomController>(context).createRoom();
      }
    });
    _gameRoomController.context = context; // Set the context for the controller
    return Scaffold(
      body: Background(
        children: [
          BlocBuilder<GameRoomController, GameRoomState>(
            builder: (context, state) {
              if (state is GameRoomLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (state is GameRoomError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: AppStyles.secondary.copyWith(fontSize: 18),
                  ),
                );
              } else if (state is WaitingRoomLoaded) {
                final String code = state.code;
                return WaitingRoomScreen(
                  code: code,
                  gameRoom: state.gameRoom,
                );
              } else if (state is QuestionGameLoaded ||
                  state is QuestionGameAnswerSent) {
                return QuestionGameScreen(
                  state: state as RoomLoaded,
                );
              }
              return Center(
                child: Text(
                  'Unexpected state',
                  style: AppStyles.secondary.copyWith(fontSize: 18),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
