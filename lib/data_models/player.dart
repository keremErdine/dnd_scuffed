import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/providers/game_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerData {
  PlayerData({required this.context});
  final BuildContext context;
  int health = 100;
  int maxHealth = 100;
  int mana = 100;
  int maxMana = 100;
  int hunger = 100;
  int maxHunger = 100;
  int daysSurvived = 0;
  int accuracy = 0;
  int gold = 10;
  int level = 1;
  int xp = 0;
  int maxXp = 5;
  int damageMultiplier = 1;
  int deathCount = 0;
  int daysSurvivedRecord = 0;
  Map<ItemIDs, int> inventory = {
    ItemIDs.tester: 5,
    ItemIDs.bread: 0,
    ItemIDs.smallHealthPotion: 0,
    ItemIDs.mediumHealthPotion: 0,
    ItemIDs.pie: 0,
    ItemIDs.largeHealthPotion: 0,
    ItemIDs.totemOfUndying: 0,
    ItemIDs.invisibilityPotion: 0,
    ItemIDs.teleporter: 0,
    ItemIDs.totemOfMadness: 0,
    ItemIDs.woodKey: 0,
    ItemIDs.ironKey: 0,
    ItemIDs.goldKey: 0,
    ItemIDs.diamondKey: 0,
    ItemIDs.ancientKey: 0,
    ItemIDs.doubleEdgesHorn: 0
  };

  void revivePlayer() {
    health = maxHealth;
    hunger = maxHunger;
    mana = maxMana;
  }

  void resetplayer() {
    deathCount = 0;
    damageMultiplier = 1;
    maxHunger = 100;
    maxMana = 100;
    maxHealth = 100;
    health = 100;
    mana = 100;
    hunger = 100;
    daysSurvived = 0;
    accuracy = 0;
    inventory.clear();
    gold = 10;
    level = 1;
    xp = 0;
    maxXp = level * 5;
    for (ItemIDs item in ItemIDs.values) {
      inventory.addAll({item: 0});
    }
    inventory[ItemIDs.bread] = 5;
    inventory[ItemIDs.smallHealthPotion] = 5;
  }

  void heal(int amount) {
    health += amount;
    if (health > maxHealth) {
      health = maxHealth;
    }
  }

  void restoreHunger(int amount) {
    hunger += amount;
    if (hunger > maxHunger) {
      hunger = maxHunger;
    }
  }

  void addGameMessage(String message) {
    context.read<GameScreenProvider>().addMessage(message);
  }

  void loseHunger(int amount) {
    if (hunger >= amount) {
      hunger -= amount;
    } else {
      if (hunger > 0) {
        amount -= hunger;
        hunger = 0;
      }
      addGameMessage(
          'AH! Açlıktan ölüyorsun! Bu eylem nedeniyle $amount sağlık puanı kaybettin!');
      takeDamage(amount, Game(context: context));
    }
  }

  void setLevel(int setLevel) {
    level = setLevel;
    maxXp = level * 5;
    maxHealth += 20 * level;
    maxHunger += 20 * level;
    maxMana += 20 * level;
    health += 20 * level;
    hunger += 20 * level;
    mana += 20 * level;
  }

  void takeDamage(int amount, game) {
    health -= amount;

    if (health <= 0) {
      if (inventory[ItemIDs.totemOfUndying]! > 0) {
        addGameMessage('ÖLÜMSÜZLÜK! Ölümsüzlük totemin seni kurtardı!');
        health = maxHealth;
        hunger = maxHunger;
        mana = maxMana;
        inventory[ItemIDs.totemOfUndying] =
            inventory[ItemIDs.totemOfUndying]! - 1;
      } else {
        if (game.isFreeplay) {
          addGameMessage('Gün biterken KAYBETTİN.');
        } else {
          addGameMessage('Gün $daysSurvived biterken KAYBETTİN.');
        }
        game.enemyAlive = false;
        game.currentTurn = Turn.none;
        game.currentEnemyData = null;
        deathCount++;

        if (!context.read<GameScreenProvider>().isFreeplay) {
          addGameMessage('$daysSurvived gün dayandın...');
          int gemsEarned = daysSurvived ~/ 5;
          game.gems += gemsEarned;
          //game.saveGems();
          addGameMessage('Bu maceradan $gemsEarned değerli taş kazandın.');
          addGameMessage(
              'Devam etmek ister misin? Bu hayatta kalınan günlerini donduracaktır.');
        } else {
          addGameMessage('Bu macerada $deathCount kere yenildin...');
          addGameMessage(
              'Zaten kaybetmiş olduğun için değerli taş kazanmadın...');
          addGameMessage('Devam etmek ister misin?');
        }
      }
    }
  }
}
