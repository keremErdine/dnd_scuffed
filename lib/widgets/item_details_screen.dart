import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen(
      {super.key,
      required this.item,
      required this.amount,
      required this.game,
      required this.stateSetter});

  final Item item;
  final int amount;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  State<ItemDetailsScreen> createState() {
    // ignore: no_logic_in_create_state
    return _ItemDetailsScreenState(
        item: item, amount: amount, game: game, stateSetter: stateSetter);
  }
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  _ItemDetailsScreenState(
      {required this.item,
      required this.amount,
      required this.game,
      required this.stateSetter});

  final Item item;
  int amount;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    int willUse = 1;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Sende bu eşyadan $amount tane var.',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  game.player.inventory[item.itemID] =
                      game.player.inventory[item.itemID]! - willUse;
                  amount--;
                });
                if (game.player.inventory[item.itemID]! <= 0) {
                  Navigator.pop(context);
                }

                game.useItems(item, willUse);
                for (var i = 1; i <= willUse; i++) {
                  stateSetter(item.itemAction);
                }
                if (game.currentTurn == Turn.enemy) {
                  stateSetter((game) {
                    game.enemyAttack();
                  });
                }
              },
              icon: const Icon(Icons.circle_outlined),
              label: Text(
                'KULLAN',
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
          ],
        ),
      ),
    );
  }
}
