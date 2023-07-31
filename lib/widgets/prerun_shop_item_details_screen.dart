import 'package:dnd_scuffed/encounters/prerun_shop.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:flutter/material.dart';

class PreRunShopItemDetailsScreen extends StatelessWidget {
  const PreRunShopItemDetailsScreen(
      {super.key,
      required this.item,
      required this.game,
      required this.gemPrice});

  final PreRunShopItem item;
  final Game game;
  final int gemPrice;

  @override
  Widget build(BuildContext context) {
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
              'Bu güçlendirmenin fiyatı $gemPrice değerli taş.',
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
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel_outlined),
              label: Text(
                'KAPAT',
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
