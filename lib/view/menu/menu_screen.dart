import 'package:flutter/material.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';
import 'package:who_is_liar/view/widgets/name_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/menum.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  NameWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuButton(
                        text: 'Create Game',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/start');
                        },
                      ),
                      MenuButton(
                        text: 'Join Game',
                        onPressed: () {
                          //Navigator.pushNamed(context, '/startGame');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
