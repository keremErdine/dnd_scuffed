import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:dnd_scuffed/main.dart';
import 'package:dnd_scuffed/widgets/item_details_screen.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen(
      {super.key,
      required this.playerInventory,
      required this.game,
      required this.stateSetter});
  final Map<ItemIDs, int> playerInventory;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    Widget body = const Center();

    if (playerInventory.values.every((element) => element == 0)) {
      body = Text('Envanterin boş.',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.error));
    } else {
      List<Widget> allItems = [];
      for (var item in items.keys) {
        allItems.add(ItemRow(
          stateSetter: stateSetter,
          item: item,
          playerInventory: playerInventory,
          game: game,
        ));
      }
      body = Center(
        child: Column(
          children: allItems,
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ENVANTER',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        body: body);
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow(
      {super.key,
      required this.item,
      required this.playerInventory,
      required this.game,
      required this.stateSetter});

  final ItemIDs item;
  final Map<ItemIDs, int> playerInventory;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    if (playerInventory[item]! > 0) {
      return Card(
        child: Row(
          children: [
            Text(
              '${items[item]!.name} x ${playerInventory[item]}',
              style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 25),
            ),
            const Spacer(),
            ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: ((context) {
                        return ItemDetailsScreen(
                          stateSetter: stateSetter,
                          item: items[item]!,
                          amount: playerInventory[item]!,
                          game: game,
                        );
                      }));
                },
                icon: const Icon(Icons.check_box_outline_blank_outlined),
                label: Text(
                  'DETAY',
                  style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 25),
                ))
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
