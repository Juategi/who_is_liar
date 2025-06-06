import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/game_room/widgets/impostor_tooltip.dart';
import 'package:who_is_liar/view/game_room/widgets/player_answer.dart';
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
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            // 'The question is: ${gameRoom?.currentQuestion?.originalQuestion ?? 'Error: No question available'}',
            '${'the_question_is'.tr()} ${gameRoom?.currentQuestion?.originalQuestion ?? 'error_no_question_available'.tr()}',
            style: AppStyles.secondary.copyWith(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
          ImpostorTooltip(
            impostorQuestion: gameRoom?.currentQuestion?.impostorQuestion ??
                'error_no_impostor_question_found'.tr(),
          ),
          QuestionTimer(
            timeUpText:
                '${'the_impostor_is'.tr()} ${gameRoomController.getImpostorName(gameRoom)}',
          ),
          Text(
            'vote_for_the_impostor'.tr(),
            style: AppStyles.secondary.copyWith(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
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
                    child: PlayerAnswer(
                      player: player,
                      gameRoom: gameRoom,
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: gameRoomController.isHost(),
            child: MenuButton(
              text: 'next_question'.tr(),
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
