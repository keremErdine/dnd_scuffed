import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/spells.dart';
import 'package:flutter/material.dart';

class SpellDetailsScreen extends StatefulWidget {
  const SpellDetailsScreen(
      {super.key,
      required this.spell,
      required this.game,
      required this.stateSetter});

  final Spell spell;

  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  State<SpellDetailsScreen> createState() {
    // ignore: no_logic_in_create_state
    return _SpellDetailsScreenState(
        spell: spell, game: game, stateSetter: stateSetter);
  }
}

class _SpellDetailsScreenState extends State<SpellDetailsScreen> {
  _SpellDetailsScreenState(
      {required this.spell, required this.game, required this.stateSetter});

  final Spell spell;

  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              spell.spellName,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Bu büyüyü yapmak ${spell.spellCost} mana gerektirir.',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              spell.spellDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
              onPressed: () {
                if (game.player.mana >= spell.spellCost) {
                  game.player.mana -= spell.spellCost;
                  stateSetter(spell.onCast);
                } else {
                  game.addMessage(
                      'Mana yetersiz. Bu büyüyü yapmak için ${spell.spellCost} mana gerekli');
                }
                if (game.player.mana <= spell.spellCost) {
                  Navigator.pop(context);
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
