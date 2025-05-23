import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/colors.dart';
import 'package:who_is_liar/settings/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.value, this.onChanged, this.labelText = ''});
  final String value;
  final String labelText;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextField(
          controller: textEditingController..text = value,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            labelText: textEditingController.text.isEmpty ? labelText : null,
            labelStyle: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 20,
            ),
          ),
          style: AppStyles.primary.copyWith(
            fontSize: 45,
            letterSpacing: 10,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
