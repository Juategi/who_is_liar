import 'package:easy_localization/easy_localization.dart';
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
        'not_impostor_tooltip'.tr(),
        style: AppStyles.secondary.copyWith(
          fontSize: 20,
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
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.red[200]!,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'impostor_tooltip'.tr(),
                  style: AppStyles.secondary.copyWith(
                    fontSize: 20,
                    color: Colors.red[200],
                  ),
                  maxLines: 8,
                ),
              ),
            ],
          ),
          Text(
            'impostor_question'.tr(args: [impostorQuestion]),
            style: AppStyles.secondary.copyWith(
              fontSize: 20,
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
