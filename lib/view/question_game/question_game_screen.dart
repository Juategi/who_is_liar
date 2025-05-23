import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/widgets/background.dart';

class QuestionGameScreen extends StatelessWidget {
  const QuestionGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Background(children: [
        Center(
          child: Text(code, style: AppStyles.primary),
        ),
      ]),
    );
  }
}
