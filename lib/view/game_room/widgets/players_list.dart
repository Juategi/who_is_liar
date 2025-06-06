import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key, required this.gameRoom});
  final GameRoom? gameRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'players'.tr(),
          style: AppStyles.secondary.copyWith(
            fontSize: 25,
          ),
        ),
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
