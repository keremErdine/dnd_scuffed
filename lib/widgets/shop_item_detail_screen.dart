import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/items.dart';
import 'package:flutter/material.dart';

class ShopItemDetailsScreen extends StatefulWidget {
  const ShopItemDetailsScreen(
      {super.key,
      required this.item,
      required this.amount,
      required this.game,
      required this.stateSetter,
      required this.price});

  final Item item;
  final int amount;
  final Game game;
  final void Function(void Function(Game)) stateSetter;
  final int price;

  @override
  State<ShopItemDetailsScreen> createState() {
    // ignore: no_logic_in_create_state
    return _ShopItemDetailsScreenState(
        item: item,
        amount: amount,
        game: game,
        stateSetter: stateSetter,
        price: price);
  }
}

class _ShopItemDetailsScreenState extends State<ShopItemDetailsScreen> {
  _ShopItemDetailsScreenState(
      {required this.item,
      required this.amount,
      required this.game,
      required this.stateSetter,
      required this.price});

  final Item item;
  final int amount;
  final Game game;
  final void Function(void Function(Game)) stateSetter;
  final int price;

  @override
  Widget build(BuildContext context) {
    int willBuy = 1;
    var icon = Icons.wallet;
    if (game.player.gold < price) {
      icon = Icons.money_off_csred_outlined;
    }

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
            Text(
              'Bu eşyanın fiyatı $price altın.',
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
                stateSetter((game) {
                  game.attemptBuyItems(item.itemID, price, willBuy);
                });
              },
              icon: Icon(icon),
              label: Text(
                'AL',
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
