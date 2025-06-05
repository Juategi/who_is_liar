import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';

class CustomTextFieldAnswer extends StatelessWidget {
  const CustomTextFieldAnswer({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        style: AppStyles.primary.copyWith(
          fontSize: 28,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          // Handle the input change if needed
        },
      ),
    );
  }
}
