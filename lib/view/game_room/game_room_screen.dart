import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/game_room/widgets/players_list.dart';
import 'package:who_is_liar/view/widgets/background.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

import 'widgets/game_code_widget.dart';

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
              } else {
                final String code = (state as GameRoomLoaded).code;
                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      spacing: 16,
                      children: [
                        GameCodeWidget(code: code),
                        const SizedBox(height: 20),
                        PlayersList(gameRoom: state.gameRoom),
                        const Spacer(),
                        Visibility(
                          visible: _gameRoomController.isHost(),
                          child: MenuButton(
                            text: 'Start game',
                            onPressed: () {
                              Navigator.pushNamed(context, '/game',
                                  arguments: code);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
