import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class ShowQuestionsScreen extends StatelessWidget {
  const ShowQuestionsScreen({super.key, required this.state});
  final RoomLoaded state;
  @override
  Widget build(BuildContext context) {
    final gameRoom = state.gameRoom;
    GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: gameRoom?.players.length ?? 0,
            itemBuilder: (context, index) {
              final player = gameRoom!.players[index];
              return Row(
                children: [
                  Text(
                    player.name,
                    style: AppStyles.secondary.copyWith(
                      fontSize: 25,
                      color: ColorUtils.randomColor(),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    player.answer ?? 'No answer',
                    style: AppStyles.secondary.copyWith(
                      fontSize: 25,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const Spacer(),
        Visibility(
          visible: gameRoomController.isHost(),
          child: MenuButton(
            text: 'Next Question',
            onPressed: () {
              gameRoomController.loadNextQuestion(state.code);
            },
          ),
        ),
      ],
    );
  }
}
