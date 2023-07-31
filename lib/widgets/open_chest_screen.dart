import 'package:dnd_scuffed/data_models/enemy_data.dart';
import 'package:dnd_scuffed/data_models/player.dart';
import 'package:dnd_scuffed/encounters/treasure.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/items.dart';

import 'package:flutter/material.dart';

class OpenChestScreen extends StatelessWidget {
  const OpenChestScreen(
      {super.key,
      required this.treasure,
      required this.player,
      required this.game,
      required this.onOpen});

  final Treasure treasure;
  final PlayerData player;
  final Game game;
  final void Function(void Function(Game)) onOpen;
  @override
  Widget build(BuildContext context) {
    var icon = Icons.key_outlined;
    if (player.inventory[treasure.requiredKey] == 0) {
      icon = Icons.key_off_outlined;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          treasure.treasureName,
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              treasure.treasureName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Sende bu sandık için ${player.inventory[treasure.requiredKey]!} tane anahtar var.',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onOpen((game) {
                  if (player.inventory[treasure.requiredKey]! == 0) {
                    game.addMessage(
                        'Bu sandığı açmak için gerekli anahtarın yok.');
                  } else {
                    player.inventory[treasure.requiredKey] =
                        player.inventory[treasure.requiredKey]! - 1;
                    game.addMessage('${treasure.treasureName} açıldı!');
                    List<ItemIDs> availableItems = treasure.availableLoot;
                    ItemIDs gotItem = availableItems[
                        randomizer.nextInt(availableItems.length)];
                    game.addMessage(
                        'İçinden ${treasure.goldReward} altın ve bir ${items[gotItem]!.name} buldun!');
                    player.gold += treasure.goldReward;
                    player.inventory[gotItem] = player.inventory[gotItem]! + 1;
                    game.currentTreasure = null;
                  }
                });
              },
              icon: Icon(icon),
              label: Text(
                'AÇ',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel_outlined),
              label: Text(
                'İPTAL',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ]),
    );
  }
}
