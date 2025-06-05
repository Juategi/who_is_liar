import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';

class InitialTooltip extends StatelessWidget {
  const InitialTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How to play?',
              style: AppStyles.secondary.copyWith(
                fontSize: 28,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              iconSize: 50,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                          'assets/images/tooltip.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
