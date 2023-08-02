import 'package:dnd_scuffed/game_objects/spells.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/main.dart';
import 'package:dnd_scuffed/game.dart';

class SpellsScreen extends StatelessWidget {
  const SpellsScreen(
      {super.key, required this.game, required this.stateSetter});

  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    Widget body = const Center();

    body = Text('Büyülerin boş.',
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.error));

    List<Widget> allSpells = [];
    for (var spell in spells.keys) {
      allSpells.add(SpellRow(
          spell: spell,
          playerSpells: const {SpellID.firebolt: 1},
          game: game,
          stateSetter: stateSetter));
    }
    body = Center(
      child: Column(
        children: allSpells,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Büyüler',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        body: body);
  }
}

class SpellRow extends StatelessWidget {
  const SpellRow(
      {super.key,
      required this.spell,
      required this.playerSpells,
      required this.game,
      required this.stateSetter});

  final SpellID spell;
  final Map<SpellID, int> playerSpells;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(
            'mogus',
            style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 25),
          ),
          const Spacer(),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_box_outline_blank_outlined),
              label: Text(
                'DETAY',
                style: kTheme.textTheme.bodyLarge!.copyWith(fontSize: 25),
              ))
        ],
      ),
    );
  }
}
