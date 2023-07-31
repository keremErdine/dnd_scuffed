import 'package:dnd_scuffed/game.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/widgets/inventory_screen.dart';
import 'package:dnd_scuffed/data_models/player_input_data.dart';
import 'package:dnd_scuffed/game_objects/items.dart';

class PlayerInputs extends StatelessWidget {
  const PlayerInputs(
      {super.key,
      required this.inputs,
      required this.playerInventory,
      required this.game,
      required this.stateSetter});

  final List<PlayerInputData> inputs;
  final Map<ItemIDs, int> playerInventory;
  final Game game;
  final void Function(void Function(Game)) stateSetter;

  @override
  Widget build(BuildContext context) {
    List<Widget> inputsBlock = [];
    if (inputs.isNotEmpty) {
      for (PlayerInputData input in inputs) {
        inputsBlock.add(InputModel(
            inputIcon: input.inputIcon,
            inputText: input.inputText,
            inputAction: input.inputAction));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        children: inputsBlock +
            [
              InputModel(
                inputIcon: Icons.backpack_outlined,
                inputText: 'ENVANTER',
                inputAction: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return InventoryScreen(
                        stateSetter: stateSetter,
                        playerInventory: playerInventory,
                        game: game,
                      );
                    },
                  );
                },
              )
            ],
      ),
    );
  }
}

class InputModel extends StatelessWidget {
  const InputModel(
      {super.key,
      required this.inputIcon,
      required this.inputText,
      required this.inputAction});

  final IconData inputIcon;
  final String inputText;
  final void Function() inputAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: inputAction,
        child: Row(
          children: [Icon(inputIcon), Text(inputText)],
        ),
      ),
    );
  }
}
