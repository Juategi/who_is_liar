import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/view/widgets/menu_button.dart';
import 'package:who_is_liar/view/widgets/name_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NameModel nameController = GetIt.instance.get<NameModel>();
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
                          if (nameController.getName().isNotEmpty) {
                            Navigator.pushNamed(context, '/start');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a name'),
                              ),
                            );
                          }
                        },
                      ),
                      MenuButton(
                        text: 'Join Game',
                        onPressed: () {
                          if (nameController.getName().isNotEmpty) {
                            Navigator.pushNamed(context, '/join');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a name'),
                              ),
                            );
                          }
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
