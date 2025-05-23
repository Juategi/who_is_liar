import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/view/widgets/custom_text_field.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final NameModel nameController = GetIt.instance.get<NameModel>();
    return FutureBuilder<String>(
      future: nameController.getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          String value = snapshot.data ?? '';
          if (value.isEmpty) {
            final name =
                'Player${DateTime.now().millisecondsSinceEpoch % 10000}';
            value = name;
            nameController.setName(name);
          }
          return CustomTextField(
            value: value,
            labelText: 'Enter your name',
            onChanged: (String newValue) {
              nameController.setName(newValue);
            },
          );
        }
      },
    );
  }
}
