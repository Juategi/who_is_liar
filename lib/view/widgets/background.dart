import 'package:flutter/material.dart';

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
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (Route<dynamic> route) => false,
                  );
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
