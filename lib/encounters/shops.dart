import 'package:dnd_scuffed/game_objects/items.dart';

enum ShopIDs {
  merchant,
  bakery,
  alchemist,
  blackMarket,
  madScientist,
  artefactCollectionist,
  locksmith
}

enum ShopRarity { common, rare, legendary, illegal }
// common: %50
// rare: %30
// legendary: %15
// illegal: %5

class Shop {
  Shop(
      {required this.shopID,
      required this.shopName,
      required this.soldItems,
      required this.shopRarity});

  final ShopIDs shopID;
  final String shopName;
  final ShopRarity shopRarity;
  // itemID: price
  final Map<ItemIDs, int> soldItems;
}

Map<ShopIDs, Shop> shops = {
  ShopIDs.merchant: Shop(
      shopID: ShopIDs.merchant,
      shopName: 'Tüccar',
      shopRarity: ShopRarity.common,
      soldItems: {
        ItemIDs.bread: 5,
        ItemIDs.smallHealthPotion: 10,
        ItemIDs.woodKey: 5
      }),
  ShopIDs.bakery: Shop(
      shopID: ShopIDs.bakery,
      shopName: 'Fırın',
      shopRarity: ShopRarity.rare,
      soldItems: {ItemIDs.bread: 3, ItemIDs.pie: 7}),
  ShopIDs.alchemist: Shop(
      shopID: ShopIDs.alchemist,
      shopName: 'İksirci',
      shopRarity: ShopRarity.legendary,
      soldItems: {
        ItemIDs.smallHealthPotion: 5,
        ItemIDs.mediumHealthPotion: 10,
        ItemIDs.largeHealthPotion: 20,
        ItemIDs.invisibilityPotion: 15
      }),
  ShopIDs.blackMarket: Shop(
      shopID: ShopIDs.blackMarket,
      shopName: 'Kara Market',
      shopRarity: ShopRarity.illegal,
      soldItems: {
        ItemIDs.smallHealthPotion: 5,
        ItemIDs.mediumHealthPotion: 10,
        ItemIDs.largeHealthPotion: 20,
        ItemIDs.bread: 3,
        ItemIDs.pie: 7,
        ItemIDs.invisibilityPotion: 15,
        ItemIDs.teleporter: 20,
        ItemIDs.totemOfUndying: 100,
        ItemIDs.totemOfMadness: 100,
        ItemIDs.woodKey: 3,
        ItemIDs.ironKey: 7,
        ItemIDs.goldKey: 15,
        ItemIDs.diamondKey: 35,
        ItemIDs.ancientKey: 70
      }),
  ShopIDs.madScientist: Shop(
      shopID: ShopIDs.madScientist,
      shopName: 'Çılgın Bilim İnsanı',
      soldItems: {ItemIDs.teleporter: 20},
      shopRarity: ShopRarity.rare),
  ShopIDs.artefactCollectionist: Shop(
      shopID: ShopIDs.artefactCollectionist,
      shopName: 'Eser Toplayıcısı',
      soldItems: {
        ItemIDs.totemOfUndying: 100,
        ItemIDs.totemOfMadness: 100,
        ItemIDs.ancientKey: 70
      },
      shopRarity: ShopRarity.legendary),
  ShopIDs.locksmith: Shop(
      shopID: ShopIDs.locksmith,
      shopName: 'Çilingir',
      soldItems: {
        ItemIDs.woodKey: 3,
        ItemIDs.ironKey: 7,
        ItemIDs.goldKey: 15,
        ItemIDs.diamondKey: 35,
      },
      shopRarity: ShopRarity.legendary)
};
