import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/view/game_room/widgets/game_code_widget.dart';
import 'package:who_is_liar/view/game_room/widgets/players_list.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen(
      {super.key, required this.code, required this.gameRoom});
  final String code;
  final GameRoom? gameRoom;
  @override
  Widget build(BuildContext context) {
    GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          spacing: 16,
          children: [
            GameCodeWidget(code: code),
            const SizedBox(height: 20),
            PlayersList(gameRoom: gameRoom),
            const Spacer(),
            Visibility(
              visible: gameRoomController.isHost(),
              child: MenuButton(
                text: 'Start game',
                onPressed: () {
                  gameRoomController.loadNextQuestion(code);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
