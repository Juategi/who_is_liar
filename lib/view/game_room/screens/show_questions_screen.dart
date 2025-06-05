import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';
import 'package:who_is_liar/view/widgets/impostor_tooltip.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class ShowQuestionsScreen extends StatelessWidget {
  const ShowQuestionsScreen({super.key, required this.state});
  final RoomLoaded state;
  @override
  Widget build(BuildContext context) {
    final gameRoom = state.gameRoom;
    GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'The question is: ${gameRoom?.currentQuestion?.originalQuestion ?? 'Error: No question available'}',
            style: AppStyles.secondary.copyWith(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          ImpostorTooltip(
            impostorQuestion: gameRoom?.currentQuestion?.impostorQuestion ??
                'Error: No impostor question found',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gameRoom?.players.length ?? 0,
              itemBuilder: (context, index) {
                final player = gameRoom!.players[index];
                return Visibility(
                  visible: player.answer != null && player.answer!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          player.name,
                          style: AppStyles.secondary.copyWith(
                            fontSize: 25,
                            color: ColorUtils.randomColor(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          player.answer!,
                          style: AppStyles.secondary.copyWith(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
