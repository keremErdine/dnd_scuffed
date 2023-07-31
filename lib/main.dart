import 'package:dnd_scuffed/providers/game_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/game_screen.dart';
import 'package:provider/provider.dart';

final kTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent));

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GameScreenProvider>(
        create: (ctx) => GameScreenProvider(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kTheme,
      home: const GameScreen(),
    ),
  ));
}
