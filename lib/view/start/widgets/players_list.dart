import 'package:flutter/material.dart';
import 'package:who_is_liar/controller/game_room.dart';
import 'package:who_is_liar/settings/styles.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key, required this.gameRoom});
  final GameRoom? gameRoom;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Players:',
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
                "${player.name} ${player.isHost ? '(You)' : ''}",
                style: AppStyles.secondary.copyWith(
                  fontSize: 25,
                  color: player.isHost ? Colors.yellow : Colors.green,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
