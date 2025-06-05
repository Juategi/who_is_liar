import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/settings/styles.dart';

class ImpostorTooltip extends StatelessWidget {
  const ImpostorTooltip({super.key, required this.impostorQuestion});
  final String impostorQuestion;
  @override
  Widget build(BuildContext context) {
    GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    return Visibility(
      visible: gameRoomController.isImpostor(),
      replacement: Text(
        'You are not the imposter! Try to guess who was the imposter based on the answers given. Discuss with each other to find out.',
        style: AppStyles.secondary.copyWith(
          fontSize: 25,
          color: Colors.green[200],
        ),
        maxLines: 8,
        textAlign: TextAlign.center,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/mask.svg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.red[200]!,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You are the impostor! Try to fool others into thinking you answered the same question.',
                  style: AppStyles.secondary.copyWith(
                    fontSize: 25,
                    color: Colors.red[200],
                  ),
                  maxLines: 8,
                ),
              ),
            ],
          ),
          Text(
            'Your impostor question was: $impostorQuestion',
            style: AppStyles.secondary.copyWith(
              fontSize: 25,
              color: Colors.red[300],
            ),
            maxLines: 8,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
