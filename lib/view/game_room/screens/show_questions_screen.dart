import 'package:flutter/material.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';

class ShowQuestionsScreen extends StatelessWidget {
  const ShowQuestionsScreen({super.key, required this.state});
  final RoomLoaded state;
  @override
  Widget build(BuildContext context) {
    final gameRoom = state.gameRoom;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: gameRoom?.players.length ?? 0,
            itemBuilder: (context, index) {
              final player = gameRoom!.players[index];
              return Text(
                player.name,
                style: AppStyles.secondary.copyWith(
                  fontSize: 25,
                  color: ColorUtils.randomColor(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
