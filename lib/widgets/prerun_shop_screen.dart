import 'package:dnd_scuffed/encounters/prerun_shop.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/main.dart';

import 'package:flutter/material.dart';

import 'package:dnd_scuffed/widgets/prerun_shop_item_details_screen.dart';

class PreRunShopScreen extends StatefulWidget {
  const PreRunShopScreen(
      {super.key, required this.stateSetter, required this.game});
  final void Function(void Function(Game)) stateSetter;
  final Game game;
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _PreRunShopScreenState(game: game, stateSetter: stateSetter);
  }
}

class _PreRunShopScreenState extends State<PreRunShopScreen> {
  _PreRunShopScreenState({
    required this.game,
    required this.stateSetter,
  });
  final Game game;
  final void Function(void Function(Game)) stateSetter;
  void preRunShopScreenStateSetter(void Function() execute) {
    setState(() {
      execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center();
    int currentGems = game.gems;

    List<Widget> allItems = [];
    for (var item in preRunShop.values) {
      allItems.add(PreRunShopRow(
        preRunShopStateSetter: preRunShopScreenStateSetter,
        preRunItem: item,
        game: game,
        gemPrice: item.gemPrice,
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
            'Macera Öncesi Dükkanı | $currentGems 💎',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        body: body);
  }
}

class PreRunShopRow extends StatelessWidget {
  const PreRunShopRow(
      {super.key,
      required this.preRunItem,
      required this.gemPrice,
      required this.game,
      required this.preRunShopStateSetter});

  final int gemPrice;
  final PreRunShopItem preRunItem;
  final Game game;
  final void Function(void Function()) preRunShopStateSetter;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(
            '${preRunItem.name}: $gemPrice 💎',
            style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 20),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((context) {
                    return PreRunShopItemDetailsScreen(
                        item: preRunItem, game: game, gemPrice: gemPrice);
                  }));
            },
            icon: const Icon(Icons.check_box_outline_blank_outlined),
            label: Text(
              'DETAY',
              style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Checkbox(
                value: game.activePreRunBuffs.contains(preRunItem.buffGiven),
                onChanged: (value) {
                  preRunShopStateSetter(() {
                    if (value!) {
                      game.activePreRunBuffs.add(preRunItem.buffGiven);
                    } else {
                      game.activePreRunBuffs.remove(preRunItem.buffGiven);
                    }
                  });
                }),
          )
        ],
      ),
    );
  }
}
