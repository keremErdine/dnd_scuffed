import 'package:dnd_scuffed/game_objects/items.dart';

enum TreasureType { wood, iron, gold, diamond, ancient }
//wood: %50
//iron: %30
//gold: %10
//diamond: %9
//ancient: %1

class Treasure {
  Treasure(
      {required this.treasureType,
      required this.availableLoot,
      required this.goldReward,
      required this.requiredKey,
      required this.treasureName});
  final TreasureType treasureType;
  final String treasureName;
  final List<ItemIDs> availableLoot;
  final int goldReward;
  final ItemIDs requiredKey;
}

Map<TreasureType, Treasure> treasures = {
  TreasureType.wood: Treasure(
      treasureName: 'Tahta Sandık',
      treasureType: TreasureType.wood,
      availableLoot: [
        ItemIDs.bread,
        ItemIDs.smallHealthPotion,
        ItemIDs.ironKey
      ],
      goldReward: 5,
      requiredKey: ItemIDs.woodKey),
  TreasureType.iron: Treasure(
      treasureName: 'Demir Sandık',
      treasureType: TreasureType.iron,
      availableLoot: [ItemIDs.pie, ItemIDs.mediumHealthPotion, ItemIDs.goldKey],
      goldReward: 10,
      requiredKey: ItemIDs.ironKey),
  TreasureType.gold: Treasure(
      treasureName: 'Altın Sandık',
      treasureType: TreasureType.gold,
      availableLoot: [
        ItemIDs.pie,
        ItemIDs.largeHealthPotion,
        ItemIDs.invisibilityPotion,
        ItemIDs.diamondKey
      ],
      goldReward: 20,
      requiredKey: ItemIDs.goldKey),
  TreasureType.diamond: Treasure(
      treasureName: 'Elmas Sandık',
      treasureType: TreasureType.diamond,
      availableLoot: [
        ItemIDs.pie,
        ItemIDs.largeHealthPotion,
        ItemIDs.teleporter,
        ItemIDs.invisibilityPotion,
        ItemIDs.ancientKey
      ],
      goldReward: 40,
      requiredKey: ItemIDs.diamondKey),
  TreasureType.ancient: Treasure(
      treasureName: 'Antik Sandık',
      treasureType: TreasureType.ancient,
      availableLoot: [ItemIDs.totemOfUndying, ItemIDs.totemOfMadness],
      goldReward: 80,
      requiredKey: ItemIDs.ancientKey)
};
