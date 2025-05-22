import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.text, this.onPressed});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      child: Text(
        text,
        style: AppStyles.primary.copyWith(
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
    );
  }
}
