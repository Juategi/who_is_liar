import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';

class PlayerAnswer extends StatefulWidget {
  const PlayerAnswer({super.key, required this.player, required this.gameRoom});
  final Player player;
  final GameRoom gameRoom;
  @override
  State<PlayerAnswer> createState() => _PlayerAnswerState();
}

class _PlayerAnswerState extends State<PlayerAnswer> {
  late Color color;
  @override
  void initState() {
    super.initState();
    color = ColorUtils.randomColor();
  }

  @override
  Widget build(BuildContext context) {
    GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${gameRoomController.getTotalVotes(widget.gameRoom, widget.player.id)} votes',
              style: AppStyles.secondary.copyWith(
                fontSize: 25,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              widget.player.name,
              style: AppStyles.secondary.copyWith(
                fontSize: 25,
                color: color,
              ),
            ),
            const Spacer(),
            Visibility(
              visible: widget.player.id !=
                  gameRoomController.getCurrentPlayer(widget.gameRoom)?.id,
              child: Radio<String>(
                value: widget.player.id,
                groupValue: gameRoomController.playerVoted,
                fillColor: WidgetStateProperty.all(color),
                onChanged: (value) {
                  setState(() {
                    gameRoomController.playerVoted = widget.player.id;
                    gameRoomController.sendVote(
                        widget.gameRoom.code, widget.player.id);
                  });
                },
              ),
            ),
          ],
        ),
        Text(
          widget.player.answer!,
          maxLines: 5,
          style: AppStyles.secondary.copyWith(
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
