import 'dart:math';

import 'package:dnd_scuffed/game_objects/enemies.dart';

final Random randomizer = Random();

class EnemyData {
  EnemyData({required this.currentEnemyID});
  final EnemyIDs currentEnemyID;
  String? enemyName;
  int? enemyLevel;
  int? enemyHealth;
  int? enemyStrenght;
  int enemyAccuracy = 0;
  String? enemyDescription;
  EnemyType? enemyType;

  void initializeEnemy() {
    enemyType = enemies[currentEnemyID]!.type;
    double powerMultiplier = 1;
    if (enemyType == EnemyType.boss) {
      powerMultiplier = 1.5;
    }

    enemyDescription = enemies[currentEnemyID]!.enemyDescription;
    enemyName = enemies[currentEnemyID]!.enemyName;
    enemyLevel = enemies[currentEnemyID]!.enemyLevel;
    enemyHealth =
        (enemyLevel! * (randomizer.nextInt(6) + 5) * powerMultiplier).round();
    enemyStrenght =
        (enemyLevel! * (randomizer.nextInt(5) + 1) * powerMultiplier).round();
  }
}
