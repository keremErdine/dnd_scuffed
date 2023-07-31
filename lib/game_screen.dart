import 'package:dnd_scuffed/data_models/player_input_data.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/main.dart';
import 'package:dnd_scuffed/providers/game_screen_provider.dart';
import 'package:dnd_scuffed/widgets/open_chest_screen.dart';
import 'package:dnd_scuffed/widgets/player_inputs.dart';
import 'package:dnd_scuffed/widgets/prerun_shop_screen.dart';
import 'package:dnd_scuffed/widgets/shop_screen.dart';
import 'package:dnd_scuffed/widgets/status_indicators_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  late Game _game;
  List<PlayerInputData> inputs = [];

  @override
  void initState() {
    super.initState();
    context.read<GameScreenProvider>().setUpMap();
    _game = Game(context: context);
    //_game.readyGame();
    inputs.add(PlayerInputData(
        inputText: 'HAZIR',
        inputIcon: Icons.check_circle_outline_outlined,
        inputAction: beginGame));
    inputs.add(PlayerInputData(
        inputText: 'MACERA ÖNCESİ DÜKKANI',
        inputIcon: Icons.shopping_cart_outlined,
        inputAction: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) =>
                  PreRunShopScreen(game: _game, stateSetter: emptyStateSetter));
        }));
  }

  void inShop() {
    setState(
      () {
        inputs.removeAt(0);
        inputs.insert(
          0,
          PlayerInputData(
            inputText: 'RAFLAR',
            inputIcon: Icons.shelves,
            inputAction: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ShopScreen(
                      playerInventory: _game.player.inventory,
                      game: _game,
                      stateSetter: emptyStateSetter,
                      shopID: _game.currentShop!.shopID,
                      itemsSold: _game.currentShop!.soldItems);
                },
              );
            },
          ),
        );
      },
    );
  }

  void enterShop() {
    setState(() {
      _game.enterShop();
    });
    inShop();
  }

  void spawnShop() {
    setState(() {
      _game.spawnShop();
      inputs.insert(
          0,
          PlayerInputData(
              inputText: 'GİR',
              inputIcon: Icons.exit_to_app_outlined,
              inputAction: enterShop));
    });
  }

  void openChest(void Function(Game) execute) {
    setState(() {
      execute(_game);
      inputs.removeAt(0);
    });
  }

  void spawnTreasure() {
    setState(() {
      _game.spawnChest();
      inputs.insert(
          0,
          PlayerInputData(
              inputText: 'AÇ',
              inputIcon: Icons.key,
              inputAction: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) => OpenChestScreen(
                          onOpen: openChest,
                          game: _game,
                          treasure: _game.currentTreasure!,
                          player: _game.player,
                        ));
              }));
    });
  }

  void continueGame() {
    setState(() {
      inputs = [
        PlayerInputData(
            inputText: 'DEVAM',
            inputIcon: Icons.forward_rounded,
            inputAction: continueGame)
      ];
      _game.continueGame();
    });

    if (_game.currentEvent == Event.battle) {
      spawnEnemy();
    } else if (_game.currentEvent == Event.shop) {
      spawnShop();
    } else if (_game.currentEvent == Event.treasure) {
      spawnTreasure();
    }
  }

  void spawnEnemy() {
    _game.spawnEnemy();
    inputs = [
      PlayerInputData(
          inputText: 'SALDIR',
          inputIcon: Icons.arrow_upward_outlined,
          inputAction: playerAttack),
      PlayerInputData(
          inputText: 'KONTROL',
          inputIcon: Icons.check_box_outlined,
          inputAction: checkEnemy),
      PlayerInputData(
          inputText: 'KAÇ',
          inputIcon: Icons.run_circle_outlined,
          inputAction: playerEscape)
    ];
  }

  void checkEnemy() {
    _game.checkEnemy();
    enemyAttack();
  }

  void battleOver() {
    inputs = [
      PlayerInputData(
          inputText: 'DEVAM',
          inputIcon: Icons.forward_rounded,
          inputAction: continueGame)
    ];
  }

  void playerEscape() {
    setState(() {
      _game.escapeFromBattle(battleOver);
    });
  }

  void emptyStateSetter(void Function(Game) execute) {
    setState(() {
      execute(_game);
    });
  }

  void enemyAttack() {
    setState(() {
      _game.enemyAttack();
      if (_game.activeBuffes.contains(Buff.immortalityActivated)) {
        playerEscape();
        _game.player.hunger = _game.player.maxHunger;
      } else if (_game.player.health <= 0) {
        inputs = [
          PlayerInputData(
              inputText: 'MACERA ÖNCESİ DÜKKANI',
              inputIcon: Icons.shopping_cart_outlined,
              inputAction: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) => PreRunShopScreen(
                        game: _game, stateSetter: emptyStateSetter));
              }),
          PlayerInputData(
            inputText: 'TEKRAR',
            inputIcon: Icons.fast_rewind_outlined,
            inputAction: beginGame,
          ),
          PlayerInputData(
              inputText: 'DEVAM',
              inputIcon: Icons.fast_forward_outlined,
              inputAction: revivePlayer)
        ];
      }
    });
  }

  void revivePlayer() {
    setState(() {
      _game.activePreRunBuffs.clear();
      _game.revivePlayer();
      inputs = [
        PlayerInputData(
            inputText: 'DEVAM',
            inputIcon: Icons.forward_rounded,
            inputAction: continueGame)
      ];
    });
  }

  void setMapObject(List<int> cords, MapObject object) {
    setState(() {
      context.read<GameScreenProvider>().map[cords[0]][cords[1]] = object;
    });
  }

  void playerAttack() {
    setState(() {
      _game.playerAttack(battleOver);
    });
    if (_game.enemyAlive) {
      enemyAttack();
    }
  }

  void beginGame() {
    setState(() {
      context.read<GameScreenProvider>().setUpMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> allMessages = context.watch<GameScreenProvider>().chatLog;
    // ignore: unused_local_variable
    List<List<MapObject>> map = context.watch<GameScreenProvider>().map;
    List<Widget> botMessages = [];
    for (String message in allMessages) {
      botMessages.add(BotMessage(message: message));
    }

    return Consumer(
      builder: (context, value, child) {
        return Row(
          children: [
            Expanded(
                child: GridView.count(
              crossAxisCount: 5,
              children: List.generate(25, (index) {
                IconData? mapIcon;
                int row = index ~/ 5;
                int col = index % 5;

                mapIcon = Icons.abc;

                if (map[col][row] == MapObject.none) {
                  mapIcon = null;
                } else if (map[col][row] == MapObject.enemy) {
                  mapIcon = Icons.dangerous;
                } else if (map[col][row] == MapObject.player) {
                  mapIcon = Icons.arrow_downward_outlined;
                } else if (map[col][row] == MapObject.dungeonEnterance) {
                  mapIcon = Icons.door_sliding_outlined;
                }

                return Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Center(
                    child: Icon(mapIcon),
                  ),
                );
              }),
            )),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: botMessages,
                    ),
                  ),
                  StatusIndicatorsBar(
                    game: _game,
                    player: _game.player,
                  ),
                  PlayerInputs(
                    stateSetter: emptyStateSetter,
                    game: _game,
                    inputs: inputs,
                    playerInventory: _game.player.inventory,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class BotMessage extends StatelessWidget {
  const BotMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Card(
          child: Row(
            children: [
              Text(
                message,
                style: kTheme.primaryTextTheme.headlineLarge!
                    .copyWith(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
