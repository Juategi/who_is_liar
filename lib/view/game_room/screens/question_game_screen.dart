import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/widgets/custom_text_field_answer.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class QuestionGameScreen extends StatelessWidget {
  const QuestionGameScreen({super.key, required this.state});
  final RoomLoaded state;

  @override
  Widget build(BuildContext context) {
    final TextEditingController answer = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            state.gameRoom?.currentQuestion?.qt ?? "No question available",
            style: AppStyles.secondary.copyWith(fontSize: 38),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: (state is QuestionGameLoaded),
            replacement: Text(
              'Answer sent successfully!',
              style: AppStyles.secondary.copyWith(fontSize: 24),
            ),
            child: CustomTextFieldAnswer(
              controller: answer,
            ),
          ),
          const Spacer(),
          Visibility(
            visible: (state is QuestionGameLoaded),
            child: MenuButton(
              text: 'Submit',
              onPressed: () {
                BlocProvider.of<GameRoomController>(context).sendAnswer(
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
