import 'package:flutter/material.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/widgets/background.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GameRoomModel gameRoom = GameRoomModel();
    return Scaffold(
      body: Background(
        children: [
          FutureBuilder<String>(
            future: Future.delayed(
                const Duration(seconds: 1), () => gameRoom.createRoom()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: AppStyles.secondary.copyWith(fontSize: 18),
                  ),
                );
              } else {
                final String code = snapshot.data!;
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
