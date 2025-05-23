import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/widgets/background.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    // Load the game room when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<GameRoomController>(context).loadGameRoom();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the GameRoomController when the screen is disposed
    // This is important to prevent memory leaks
    BlocProvider.of<GameRoomController>(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      children: [
                        Text(
                          'Game code:',
                          style: AppStyles.secondary.copyWith(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          code,
                          style: AppStyles.secondary.copyWith(
                            fontSize: 32,
                          ),
                        ),
                        const Spacer(),
                        MenuButton(
                          text: 'Start game',
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
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
