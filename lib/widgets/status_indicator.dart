import 'package:flutter/material.dart';
import 'package:dnd_scuffed/main.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator(
      {super.key,
      required this.statusIcon,
      required this.statusValue,
      this.maxValue});

  final IconData statusIcon;
  final int statusValue;
  final int? maxValue;

  @override
  Widget build(BuildContext context) {
    String maxString = '';
    if (maxValue != null) {
      maxString = '/$maxValue';
    }

    return SizedBox(
      width: 100,
      child: Card(
        child: Center(
          child: Row(
            children: [
              Icon(statusIcon),
              Text(
                statusValue.toString() + maxString,
                style: kTheme.copyWith().textTheme.labelLarge,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
