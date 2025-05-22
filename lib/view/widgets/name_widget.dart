import 'package:flutter/material.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/settings/colors.dart';
import 'package:who_is_liar/settings/styles.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final NameModel nameController = NameModel();
    final TextEditingController textEditingController = TextEditingController();
    return FutureBuilder<String>(
      future: nameController.getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final value = snapshot.data ?? '';
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
                  labelText:
                      textEditingController.text.isEmpty ? 'Your name' : null,
                  labelStyle: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                  ),
                ),
                style: AppStyles.primary.copyWith(
                  fontSize: 45,
                  letterSpacing: 10,
                ),
                onChanged: (newValue) async {
                  nameController.setName(newValue);
                },
              ),
            ),
          );
        }
      },
    );
  }
}
