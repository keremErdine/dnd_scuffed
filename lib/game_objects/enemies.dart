import 'package:dnd_scuffed/game_objects/items.dart';

class Enemy {
  Enemy(
      {required this.enemyName,
      required this.enemyLevel,
      required this.enemyDescription,
      required this.type,
      required this.drops});

  final EnemyType type;
  final String enemyName;
  final int enemyLevel;
  final String enemyDescription;
  final List<ItemIDs> drops;
}

enum EnemyType { normal, boss, special }

enum EnemyIDs { goblin, wolf, zombie, earthGolem, undeadKnight, windigo }

Map<EnemyIDs, Enemy> enemies = {
  EnemyIDs.goblin: Enemy(
      enemyName: 'Goblin',
      enemyLevel: 1,
      enemyDescription: 'Zayıf bir goblin',
      drops: [],
      type: EnemyType.normal),
  EnemyIDs.wolf: Enemy(
      enemyName: 'Kurt',
      enemyLevel: 3,
      enemyDescription: 'Etçil bir hayvan',
      drops: [ItemIDs.bread],
      type: EnemyType.normal),
  EnemyIDs.zombie: Enemy(
      enemyName: 'Zombi',
      enemyLevel: 5,
      enemyDescription: 'Kara büyü ile diriltilmiş bir ceset',
      drops: [ItemIDs.pie, ItemIDs.woodKey],
      type: EnemyType.normal),
  EnemyIDs.earthGolem: Enemy(
      enemyName: 'Toprak Golemi',
      enemyLevel: 7,
      enemyDescription: 'Toprak büyüsü kullanarak sana saldıran bir golem',
      drops: [ItemIDs.mediumHealthPotion, ItemIDs.woodKey],
      type: EnemyType.normal),
  EnemyIDs.undeadKnight: Enemy(
      enemyName: 'Zombi Şovalye',
      enemyLevel: 10,
      enemyDescription:
          'Karşılaşacağın muhtemelen ilk patron. Normal yaratıklardan çok daha güçlü ama değerli.',
      drops: [ItemIDs.ironKey, ItemIDs.largeHealthPotion],
      type: EnemyType.boss),
  EnemyIDs.windigo: Enemy(
      enemyName: 'Wendigo',
      enemyLevel: 10,
      enemyDescription: 'Ağaçların arasından çıkan bir yaratık.',
      type: EnemyType.special,
      drops: [ItemIDs.doubleEdgesHorn])
};
