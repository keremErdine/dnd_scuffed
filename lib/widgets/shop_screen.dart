import 'package:dnd_scuffed/encounters/shops.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:dnd_scuffed/main.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/widgets/shop_item_detail_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen(
      {super.key,
      required this.playerInventory,
      required this.game,
      required this.stateSetter,
      required this.shopID,
      required this.itemsSold});
  final ShopIDs shopID;
  final Map<ItemIDs, int> itemsSold;
  final Map<ItemIDs, int> playerInventory;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    Widget body = const Center();

    List<Widget> allItems = [];
    for (var item in itemsSold.keys) {
      allItems.add(ShopRow(
        stateSetter: stateSetter,
        item: item,
        playerInventory: playerInventory,
        game: game,
        price: itemsSold[item]!,
      ));

      body = Center(
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: allItems,
            ))
          ],
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            shops[shopID]!.shopName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        body: body);
  }
}

class ShopRow extends StatelessWidget {
  const ShopRow(
      {super.key,
      required this.item,
      required this.price,
      required this.playerInventory,
      required this.game,
      required this.stateSetter});

  final int price;
  final ItemIDs item;
  final Map<ItemIDs, int> playerInventory;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(
            '${items[item]!.name}: $price altın',
            style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 20),
          ),
          const Spacer(),
          ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((context) {
                      return ShopItemDetailsScreen(
                        price: price,
                        stateSetter: stateSetter,
                        item: items[item]!,
                        amount: playerInventory[item]!,
                        game: game,
                      );
                    }));
              },
              icon: const Icon(Icons.check_box_outline_blank_outlined),
              label: Text(
                'DETAY/AL',
                style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
