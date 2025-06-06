import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';

class GameCodeWidget extends StatelessWidget {
  const GameCodeWidget({super.key, required this.code});
  final String code;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Text(
          'game_code'.tr(),
          style: AppStyles.secondary.copyWith(
            fontSize: 25,
          ),
        ),
        Text(
          code,
          style: AppStyles.secondary.copyWith(
            fontSize: 32,
          ),
        ),
      ],
    );
  }
}
