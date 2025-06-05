import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/utils/color_utils.dart';
import 'package:who_is_liar/view/game_room/widgets/impostor_tooltip.dart';
import 'package:who_is_liar/view/game_room/widgets/question_timer.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class ShowAnswersScreen extends StatelessWidget {
  const ShowAnswersScreen({super.key, required this.state});
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
          const SizedBox(height: 40),
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
          QuestionTimer(
            timeUpText:
                'The impostor is ${gameRoomController.getImpostorName(gameRoom)}',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gameRoom?.players.length ?? 0,
              itemBuilder: (context, index) {
                final player = gameRoom!.players[index];
                String value = '';
                return Visibility(
                  visible: player.answer != null && player.answer!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              player.name,
                              style: AppStyles.secondary.copyWith(
                                fontSize: 25,
                                color: ColorUtils.randomColor(),
                              ),
                            ),
                            Visibility(
                              visible: player.id !=
                                  gameRoomController
                                      .getCurrentPlayer(gameRoom)
                                      ?.id,
                              child: Radio<String>(
                                value: value,
                                groupValue: player.id,
                                onChanged: (value) {
                                  value = player.id;
                                },
                              ),
                            ),
                          ],
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
