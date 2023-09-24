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

enum EnemyType { normal, boss, floorBoss }

enum EnemyIDs {
  goblin,
  wolf,
  zombie,
  earthGolem,
  undeadKnight,
  windigo,
  skeletonArcher,
  armoredZombie,
  bandit,
  exiled,
  sugomabot
}

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
      enemyDescription:
          'Ağaçların arasından çıkan ve insan yiyen bir yaratık. Sonraki kata geçmek için öldür.',
      type: EnemyType.floorBoss,
      drops: [ItemIDs.doubleEdgedHorn]),
  EnemyIDs.skeletonArcher: Enemy(
      enemyName: 'İskelet Okçu',
      enemyLevel: 9,
      enemyDescription: 'Yayı olan bir iskelet. Bana bir şeyi hatırlatıyor.',
      type: EnemyType.normal,
      drops: [ItemIDs.goldKey, ItemIDs.mediumHealthPotion]),
  EnemyIDs.armoredZombie: Enemy(
      enemyName: 'Zırhlı Zombi',
      enemyLevel: 12,
      enemyDescription:
          'Bu zombi, normal bir zombiden daha güçlü çünkü zırhlı.',
      type: EnemyType.normal,
      drops: [ItemIDs.pie, ItemIDs.largeHealthPotion]),
  EnemyIDs.bandit: Enemy(
      enemyName: 'Haydut',
      enemyLevel: 14,
      enemyDescription: 'Silahlı bir kanunsuz. Adam sağlam yani.',
      type: EnemyType.normal,
      drops: [ItemIDs.goldKey, ItemIDs.largeHealthPotion]),
  EnemyIDs.exiled: Enemy(
      enemyName: 'Sürgün',
      enemyLevel: 20,
      enemyDescription:
          'Ülkesinden sürülmüş bir savaşçı. Önüne çıkan herkesi öldürür.',
      type: EnemyType.floorBoss,
      drops: [ItemIDs.totemOfMadness]),
  EnemyIDs.sugomabot: Enemy(
      enemyName: 'SUGOMABOT',
      enemyLevel: 125,
      enemyDescription: 'Çok affedersin ama oyunu bitiremezsin.',
      type: EnemyType.floorBoss,
      drops: []),
};
