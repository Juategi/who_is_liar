import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/game_room/widgets/custom_text_field_answer.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class QuestionGameScreen extends StatelessWidget {
  const QuestionGameScreen({super.key, required this.state});
  final RoomLoaded state;

  @override
  Widget build(BuildContext context) {
    final TextEditingController answer = TextEditingController();
    final GameRoomController gameRoomController =
        BlocProvider.of<GameRoomController>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 45),
          AnimatedTextKit(
            isRepeatingAnimation: false,
            repeatForever: false,
            totalRepeatCount: 1,
            animatedTexts: [
              TyperAnimatedText(
                (gameRoomController.isImpostor()
                        ? state.gameRoom?.currentQuestion?.impostorQuestion
                        : state.gameRoom?.currentQuestion?.originalQuestion) ??
                    "No question available",
                textStyle: AppStyles.secondary.copyWith(fontSize: 38),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: (state is QuestionGameLoaded),
            replacement: Column(
              children: [
                Text(
                  'Answer sent successfully!',
                  style: AppStyles.secondary.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Text(
                  gameRoomController.getCurrentPlayer(state.gameRoom)?.answer ??
                      'No answer provided',
                  style: AppStyles.secondary.copyWith(fontSize: 30),
                ),
              ],
            ),
            child: CustomTextFieldAnswer(
              controller: answer,
            ),
          ),
          const Spacer(),
          Visibility(
            visible: (state is QuestionGameLoaded),
            replacement: Visibility(
              visible: gameRoomController.isHost(),
              child: MenuButton(
                text: 'See answers',
                onPressed: () {
                  gameRoomController.showAnswers(state.code);
                },
              ),
            ),
            child: MenuButton(
              text: 'Submit',
              onPressed: () {
                gameRoomController.sendAnswer(
                  state.code,
                  answer.text,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
