import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';
import 'package:who_is_liar/view/widgets/background.dart';
import 'package:who_is_liar/view/widgets/custom_text_field.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';

class JoinRoomScreen extends StatelessWidget {
  const JoinRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String code = '';
    return Scaffold(
      body: Background(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              'Write the game code:',
              style: AppStyles.secondary.copyWith(
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CustomTextField(
                value: '',
                onChanged: (String newValue) {
                  code = newValue;
                },
              ),
            ),
            const Spacer(),
            MenuButton(
              text: 'Join game',
              onPressed: () {
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a code'),
                      behavior: SnackBarBehavior.floating,
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 100),
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, '/start', arguments: code);
              },
            ),
          ],
        ),
      ]),
    );
  }
}
