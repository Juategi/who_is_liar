import 'package:flutter/material.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';

class QuestionGameScreen extends StatelessWidget {
  const QuestionGameScreen({super.key, required this.state});
  final QuestionGameLoaded state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Current Question: ${state.gameRoom?.currentQuestion?.qt ?? "No question available"}',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }
}
