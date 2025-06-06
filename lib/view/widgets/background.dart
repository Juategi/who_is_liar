import 'package:flutter/material.dart';
import 'package:rebirth/rebirth.dart';
import 'package:who_is_liar/settings/di.dart';

class Background extends StatelessWidget {
  const Background({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/back.png',
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                iconSize: 28,
                onPressed: () async {
                  await Di.setup();
                  // ignore: use_build_context_synchronously
                  WidgetRebirth.createRebirth(context: context);
                },
              ),
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
