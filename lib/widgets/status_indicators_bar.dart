import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/widgets/status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/data_models/player.dart';

class StatusIndicatorsBar extends StatelessWidget {
  const StatusIndicatorsBar(
      {super.key, required this.player, required this.game});

  final PlayerData player;
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: [
          Row(
            children: [
              StatusIndicator(
                statusIcon: Icons.health_and_safety_outlined,
                statusValue: player.health,
                maxValue: player.maxHealth,
              ),
              StatusIndicator(
                statusIcon: Icons.auto_fix_high_outlined,
                statusValue: player.mana,
                maxValue: player.maxMana,
              ),
              StatusIndicator(
                statusIcon: Icons.lunch_dining_outlined,
                statusValue: player.hunger,
                maxValue: player.maxHunger,
              ),
              StatusIndicator(
                statusIcon: Icons.task_alt_sharp,
                statusValue: player.accuracy,
                maxValue: 10,
              ),
            ],
          ),
          Row(
            children: [
              StatusIndicator(
                statusIcon: Icons.star_outline,
                statusValue: player.level,
              ),
              StatusIndicator(
                statusIcon: Icons.menu_book_outlined,
                statusValue: player.xp,
                maxValue: player.maxXp,
              ),
              StatusIndicator(
                  statusIcon: Icons.attach_money_outlined,
                  statusValue: player.gold),
              StatusIndicator(
                  statusIcon: game.daysSurvivedIcon,
                  statusValue: player.daysSurvived),
              StatusIndicator(
                  statusIcon: Icons.stacked_bar_chart_outlined,
                  statusValue: game.currentFloor)
            ],
          ),
        ],
      ),
    );
  }
}
