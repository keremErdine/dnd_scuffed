import 'package:flutter/material.dart';

class PlayerInputData {
  PlayerInputData(
      {required this.inputText,
      required this.inputIcon,
      required this.inputAction});

  final String inputText;
  final IconData inputIcon;
  void Function() inputAction;
}
