import 'package:dnd_scuffed/data_models/enemy_data.dart';
import 'package:dnd_scuffed/data_models/player.dart';
import 'package:dnd_scuffed/encounters/prerun_shop.dart';
import 'package:dnd_scuffed/encounters/shops.dart';
import 'package:dnd_scuffed/encounters/treasure.dart';
import 'package:dnd_scuffed/game_objects/enemies.dart';
import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:dnd_scuffed/providers/game_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Turn { player, enemy, none }

enum Event { battle, shop, treasure, none }

enum Buff { invisible, mad, immortalityActivated, firebolt }

enum MapObject {
  mage,
  player,
  enemy,
  shop,
  treasure,
  preRunShop,
  floorLadder,
  dungeonEnterance,
  none
}

class Game {
  Game({required this.context}) : player = PlayerData(context: context);
  final BuildContext context;
  final PlayerData player;

  //SharedPreferences? prefs;

  int currentFloor = 0;
  List<AllPreRunBuffes> activePreRunBuffs = [];
  bool enemyAlive = false;
  EnemyData? currentEnemyData;
  Turn currentTurn = Turn.none;
  Event currentEvent = Event.none;
  Shop? currentShop;
  Treasure? currentTreasure;
  bool metShop = false;
  bool metTreasure = false;
  List<Buff> activeBuffes = [];
  bool isFreeplay = false;
  int gems = 0;
  var daysSurvivedIcon = Icons.calendar_month_outlined;
  bool affordsPreRunBuffes = false;
  List<int>? currentEnemyCords;
  bool inEvent = false;

  /*
  void setSharedPreferances() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveGems() async {
    await prefs!.setInt('gems', gems);
  }

  void readyGame() async {
    setSharedPreferances();
    loadGems();
  }*/

  //void loadGems() async {
  //int? willBeSetGems = prefs!.getInt('gems')!;
  //gems = willBeSetGem>;
  // }

  void addMessage(String message) {
    context.read<GameScreenProvider>().addMessage(message);
  }

  void spawnMage() {}

  void spawnShop() {
    int shopRarityDecider = randomizer.nextInt(100) + 1;
    ShopRarity shopRarity = ShopRarity.common;
    if (shopRarityDecider <= 50) {
      shopRarity = ShopRarity.common;
    } else if (shopRarityDecider <= 80) {
      shopRarity = ShopRarity.rare;
    } else if (shopRarityDecider <= 95) {
      shopRarity = ShopRarity.legendary;
    } else {
      shopRarity = ShopRarity.illegal;
    }
    List<ShopIDs> availableShopIDs = [];
    shops.forEach((key, value) {
      if (value.shopRarity == shopRarity) {
        availableShopIDs.add(key);
      }
    });
    metShop = true;
    ShopIDs selectedShopID =
        availableShopIDs[randomizer.nextInt(availableShopIDs.length)];
    currentShop = shops[selectedShopID];
    addMessage('Bu dükkan bir ${currentShop!.shopName}!');
  }

  void continueGame() {
    context.read<GameScreenProvider>().clearMessages;
    addMessage('İlerlemeye devam ediyorsun...');
    int nextEvent = randomizer.nextInt(3) + 1;
    while (true) {
      if (nextEvent == 1) {
        currentEvent = Event.battle;
        addMessage('ve karşına bir düşman çıkıyor!');
        break;
      } else if (nextEvent == 2 && !metShop) {
        currentEvent = Event.shop;
        addMessage('ve bir dükkana geliyorsun!');
        break;
      } else if (nextEvent == 3 && !metTreasure) {
        currentEvent = Event.treasure;
        addMessage('ve hazine buluyorsun!');
        break;
      } else {
        nextEvent = randomizer.nextInt(3) + 1;
      }
    }
  }

  void spawnChest() {
    metTreasure = true;
    int treasureTypeDecider = randomizer.nextInt(100) + 1;
    TreasureType treasureType = TreasureType.wood;
    if (treasureTypeDecider <= 50) {
      treasureType = TreasureType.wood;
    } else if (treasureTypeDecider <= 80) {
      treasureType = TreasureType.iron;
    } else if (treasureTypeDecider <= 90) {
      treasureType = TreasureType.gold;
    } else if (treasureTypeDecider <= 99) {
      treasureType = TreasureType.diamond;
    } else {
      treasureType = TreasureType.ancient;
    }
    currentTreasure = treasures[treasureType];
    addMessage('Bu bir ${currentTreasure!.treasureName}!');
  }

  void enterShop() {
    addMessage('Bu dükkanda satılan mallar: ');
    for (ItemIDs item in currentShop!.soldItems.keys) {
      addMessage('${items[item]!.name}: ${currentShop!.soldItems[item]} altın');
    }
  }

  void spawnEnemy() {
    List<EnemyIDs> allEnemies = List<EnemyIDs>.from(EnemyIDs.values);
    List<EnemyIDs> availableEnemies = [];
    for (var enemyID in allEnemies) {
      if (enemies[enemyID]!.enemyLevel <= currentFloor &&
          enemies[enemyID]!.type != EnemyType.floorBoss) {
        availableEnemies.add(enemyID);
      }
    }
    EnemyIDs selectedEnemyID =
        availableEnemies[randomizer.nextInt(availableEnemies.length)];
    currentEnemyData = EnemyData(currentEnemyID: selectedEnemyID);
    currentEnemyData!.initializeEnemy();
    currentTurn = Turn.player;
    enemyAlive = true;
    addMessage('Düşmanın bir ${currentEnemyData!.enemyName}!');
  }

  void checkEnemy() {
    addMessage(
        'Seviye ${currentEnemyData!.enemyLevel} ${currentEnemyData!.enemyName}: ${currentEnemyData!.enemyDescription}. Sağlık ${currentEnemyData!.enemyHealth} | Kuvvet ${currentEnemyData!.enemyStrenght}');
    addMessage('Turunu rakibini kontrol ederken harcadın! Sıra rakibinde!');
    currentTurn = Turn.enemy;
  }

  void escapeFromBattle(void Function() battleOver) {
    if (player.inventory[ItemIDs.teleporter]! > 0) {
      addMessage('IŞINLANDIN! Bu dövüşten açlık puanı harcamadan kaçtın!');
      player.inventory[ItemIDs.teleporter] =
          player.inventory[ItemIDs.teleporter]! - 1;
    } else {
      int hungerLoss = currentEnemyData!.enemyHealth! * 3;
      addMessage(
          'KAÇTIN! Bu dövüşten kaçtın ama kaçarken $hungerLoss açlık puanı kaybettin.');
      player.loseHunger(hungerLoss);
      if (player.health <= 0) {
        return;
      }
    }
    currentEnemyData = null;
    currentTurn = Turn.none;
    enemyAlive = false;
    battleOver();
    if (!isFreeplay) {
      player.daysSurvived++;
    }
  }

  void useItems(Item item, int amount) {
    addMessage('$amount ${item.name} kullandın.');
    if (currentTurn == Turn.player) {
      addMessage('Sıranı bir eşya kullanarak harcadın!');
      currentTurn = Turn.enemy;
      if (!isFreeplay) {
        player.daysSurvived++;
      }
    }
  }

  void levelUp() {
    player.level++;
    player.xp -= player.maxXp;
    player.maxXp = player.level * 5;
    player.maxHealth += 20;
    player.maxHunger += 20;
    player.maxMana += 20;
    player.health += 20;
    player.hunger += 20;
    player.mana += 20;
    addMessage('YAŞASIN! Seviye ${player.level} oldun!');
  }

  void enemyAttack() {
    if (activeBuffes.contains(Buff.invisible)) {
      addMessage(
          'GÖRÜNMEZLİK! Görünmezliğin seni bu saldırıdan kurtardı ama etkisi geçti!');
      activeBuffes.remove(Buff.invisible);
    } else {
      final int damage =
          randomizer.nextInt(currentEnemyData!.enemyStrenght!) + 1;
      if (randomizer.nextInt(100) < (10 - currentEnemyData!.enemyAccuracy)) {
        addMessage(
            'ISKA! Karşındaki ${currentEnemyData!.enemyName} tutarlığını 1 arttırdı.');
        currentEnemyData!.enemyAccuracy++;
      } else {
        addMessage('AH! $damage hasar aldın!');
        if (currentEnemyData!.enemyAccuracy > 0) {
          addMessage(
              'Karşındaki ${currentEnemyData!.enemyName} başarılı bir saldırı yaptığı için tutarlılığı sıfırlandı.');
          currentEnemyData!.enemyAccuracy = 0;
        }
        player.takeDamage(damage, this);
      }
    }

    currentTurn = Turn.player;
    if (!isFreeplay) {
      player.daysSurvived++;
      addMessage(
          'Gün ${player.daysSurvived} biterken ${player.health} sağlığın kaldı.');
    } else {
      addMessage('Gün biterken ${player.health} sağlığın kaldı.');
    }
  }

  void revivePlayer() {
    isFreeplay = true;
    daysSurvivedIcon = Icons.not_interested;
    player.revivePlayer();
  }

  void playerAttack(void Function() battleOver) {
    if (currentTurn == Turn.player) {
      final int damage = randomizer.nextInt(player.level * 5) + 1;
      final int multipliedDamage = damage * player.damageMultiplier;
      final int hungerLoss = (damage ~/ 3) + 1;
      if (activeBuffes.contains(Buff.mad)) {
        activeBuffes.remove(Buff.mad);
        addMessage(
            'AAARGH! Deli olduğundan hasarın 5 kat arttı! Ama etkisi geçiyor...');
      }
      if (activeBuffes.contains(Buff.firebolt)) {
        activeBuffes.remove(Buff.firebolt);
        addMessage('Ateştopunu düşmanına fırlattın!');
      }
      player.damageMultiplier = 1;
      if (randomizer.nextInt(100) < (10 - player.accuracy)) {
        addMessage(
            'ISKALADIN! Bunun için $hungerLoss açlık puanı kaybettin. Ama tutarlığın 1 arttı.');
        player.accuracy += 1;
      } else {
        addMessage(
            'BAM! Karşındaki ${currentEnemyData!.enemyName} $multipliedDamage hasar aldı! Bu saldırıyı yaparken $hungerLoss açlık puanı kaybettin.');
        if (player.accuracy > 0) {
          addMessage(
              'Başarılı bir saldırı yaptığın için tutarlılığın sıfırlandı.');
          player.accuracy = 0;
        }
        currentEnemyData!.enemyHealth =
            currentEnemyData!.enemyHealth! - multipliedDamage;
      }
      player.loseHunger(hungerLoss);
      currentTurn = Turn.enemy;

      if (currentEnemyData!.enemyHealth! <= 0) {
        if (!isFreeplay) {
          addMessage(
              'Gün ${player.daysSurvived} biterken karşındaki ${currentEnemyData!.enemyName}, yerde cansız bir halde yatıyor...');
          player.daysSurvived++;
        } else {
          addMessage(
              'Gün biterken karşındaki ${currentEnemyData!.enemyName}, yerde cansız bir halde yatıyor...');
        }
        if (currentEnemyData!.enemyType == EnemyType.floorBoss) {
          addMessage(
              'Başardın! Kat patronu ${currentEnemyData!.enemyName} yenildi ve sonraki kata giden yol açıldı!');
        }

        enemyAlive = false;
        currentTurn = Turn.none;
        int xpEarn = currentEnemyData!.enemyLevel! * randomizer.nextInt(5) + 1;
        int goldEarn =
            currentEnemyData!.enemyLevel! * randomizer.nextInt(3) + 1;
        addMessage(
            '${currentEnemyData!.enemyName} YENİLDI! Bu sayede $xpEarn deneyim ve $goldEarn altın kazandın!');
        if (randomizer.nextInt(100) < 15 &&
            enemies[currentEnemyData!.currentEnemyID]!.drops.isNotEmpty &&
            currentEnemyData!.enemyType != EnemyType.floorBoss) {
          ItemIDs gotItem = enemies[currentEnemyData!.currentEnemyID]!.drops[
              randomizer.nextInt(
                  enemies[currentEnemyData!.currentEnemyID]!.drops.length)];
          player.inventory[gotItem] = player.inventory[gotItem]! + 1;
          addMessage('Rakibinin üstünde bir ${items[gotItem]!.name} buldun!');
        } else if (currentEnemyData!.enemyType == EnemyType.floorBoss) {
          addMessage(
              'Bu yaratığın üstünde ${enemies[currentEnemyData!.currentEnemyID]!.drops[0]} buldun!');
          player.inventory[enemies[currentEnemyData!.currentEnemyID]!
              .drops[0]] = player.inventory[
                  enemies[currentEnemyData!.currentEnemyID]!.drops[0]]! +
              1;
        }
        player.gold += goldEarn;
        player.xp += xpEarn;
        if (player.xp >= player.maxXp) {
          levelUp();
        }
        battleOver();

        currentEnemyData = null;
      } else {
        if (isFreeplay) {
          addMessage(
              'Gün biterken karşındaki ${currentEnemyData!.enemyName} saldırmaya hazırlanıyor...');
        } else {
          addMessage(
              'Gün ${player.daysSurvived} biterken karşındaki ${currentEnemyData!.enemyName} saldırmaya hazırlanıyor...');
          player.daysSurvived++;
        }
      }
    }
  }

  void startGame() {
    int totalPreRunBuffPrice = 0;
    for (var preRunBuff in activePreRunBuffs) {
      totalPreRunBuffPrice += preRunShop[preRunBuff]!.gemPrice;
    }
    if (totalPreRunBuffPrice > gems) {
      addMessage('Yeteri kadar değerli taşın yok!');
      affordsPreRunBuffes = false;
      return;
    } else {
      affordsPreRunBuffes = true;
    }
    gems -= totalPreRunBuffPrice;
    //saveGems();
    player.resetplayer();
    if (activePreRunBuffs.contains(AllPreRunBuffes.moreBread)) {
      player.inventory[ItemIDs.bread] = 10;
    }
    if (activePreRunBuffs.contains(AllPreRunBuffes.instaLevels)) {
      player.setLevel(3);
    }
    activePreRunBuffs.clear();
    currentEvent = Event.none;
    enemyAlive = false;
    currentTurn = Turn.none;
    isFreeplay = false;
    daysSurvivedIcon = Icons.calendar_month_outlined;
  }

  void attemptBuyItems(ItemIDs itemID, int price, int amount) {
    if (player.gold >= (price * amount)) {
      player.inventory[itemID] = player.inventory[itemID]! + amount;
      player.gold -= price * amount;
      addMessage(
          '${price * amount} altın fiyatına, bir ${items[itemID]!.name} aldın.');
    } else {
      addMessage(
          'Paran yetersiz. Bu eşyayı almak için ${(price * amount) - player.gold} altın daha toplamalısın.');
    }
  }
}
