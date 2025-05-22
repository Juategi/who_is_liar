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
        ...children,
      ],
    );
  }
}
