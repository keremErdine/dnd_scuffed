import 'dart:js_interop';

import 'package:dnd_scuffed/data_models/enemy_data.dart';
import 'package:dnd_scuffed/data_models/player_input_data.dart';
import 'package:dnd_scuffed/game.dart';
import 'package:dnd_scuffed/game_objects/enemies.dart';
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
  late List<int> playerCords;
  //col, row

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

  void spawnShop(List<int> cords) {
    setState(() {
      _game.spawnShop();
      inputs.insert(
          0,
          PlayerInputData(
              inputText: 'GİR',
              inputIcon: Icons.exit_to_app_outlined,
              inputAction: enterShop));
      inputs.insert(
          0,
          PlayerInputData(
              inputText: 'DEVAM',
              inputIcon: Icons.arrow_right_alt_outlined,
              inputAction: () {
                setState(() {
                  setMapObject(cords, MapObject.none);
                  inputs.clear();
                });
              }));
    });
  }

  void openChest(void Function(Game) execute) {
    setState(() {
      execute(_game);
      _game.inEvent = false;
      inputs.clear();
    });
  }

  void spawnTreasure(List<int> treasureCords) {
    setState(() {
      _game.spawnChest();
      _game.inEvent = true;
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
      inputs.insert(
          1,
          PlayerInputData(
              inputText: 'DEVAM',
              inputIcon: Icons.arrow_right_alt_outlined,
              inputAction: () {
                setState(() {
                  setMapObject(treasureCords, MapObject.none);
                  inputs.clear();
                  _game.inEvent = false;
                });
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
      spawnShop([0, 0]);
    } else if (_game.currentEvent == Event.treasure) {
      spawnTreasure([0, 0]);
    }
  }

  void spawnEnemy() {
    setState(() {
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
    });
  }

  void checkEnemy() {
    _game.checkEnemy();
    enemyAttack();
  }

  void battleOver() {
    inputs = [];
    setMapObject(_game.currentEnemyCords!, MapObject.none);
    _game.currentEnemyCords = null;
    if (_game.currentEnemyData!.enemyType == EnemyType.floorBoss) {
      enterFloor(_game.currentFloor, context.read<GameScreenProvider>().map);
    }
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

  void summonFloorBoss(EnemyIDs bossId) {
    _game.currentEnemyData = EnemyData(currentEnemyID: bossId);
    _game.currentEnemyData!.initializeEnemy();
    _game.currentTurn = Turn.player;
    _game.enemyAlive = true;
    setState(() {
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
    });
  }

  void enterFloor(int floor, List<List<MapObject>> map) {
    if (floor == 6) {
      _game.addMessage('Bir yaratık yaklaşıyor! Dikkat et!');
      summonFloorBoss(EnemyIDs.windigo);
      _game.addMessage(
          'EYVAH! Bu bir WENDİGO, insanları öldürüp onları yiyen orman yaratığı! ÇABUK ÖLDÜR ONU!');
    }
    if (!_game.enemyAlive) {
      bool exitBuilt = false;
      int stores = 0;
      int treasures = 0;

      context.read<GameScreenProvider>().addMessage('KAT $floor...');
      setState(() {
        List<int> currentCords = [0, 0];

        for (var element in map) {
          // ignore: unused_local_variable
          for (var square in element) {
            int randomNumber = randomizer.nextInt(6);
            if (randomNumber == 0 || randomNumber == 1) {
              setMapObject([currentCords[0], currentCords[1]], MapObject.enemy);
            } else if ((randomNumber == 2 || currentCords == [4, 4]) &&
                !exitBuilt &&
                currentCords != [4, 2]) {
              setMapObject(
                  [currentCords[0], currentCords[1]], MapObject.floorLadder);
              exitBuilt = true;
            } else if (randomNumber == 3 && !(stores >= 3)) {
              stores++;
              setMapObject([currentCords[0], currentCords[1]], MapObject.shop);
            } else if (randomNumber == 4 && !(treasures >= 3)) {
              treasures++;
              setMapObject(
                  [currentCords[0], currentCords[1]], MapObject.treasure);
            } else {
              setMapObject([currentCords[0], currentCords[1]], MapObject.none);
            }
            currentCords[1]++;
          }
          currentCords[0]++;

          currentCords[1] = 0;
        }
        setMapObject([4, 2], MapObject.player);
        playerCords = [4, 2];
      });
    }
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

  void setMapObject(List<int> cords, MapObject object, {List<int>? oldCords}) {
    setState(() {
      if (!oldCords.isNull) {
        context.read<GameScreenProvider>().map[oldCords![0]][oldCords[1]] =
            MapObject.none;
      }
      context.read<GameScreenProvider>().map[cords[0]][cords[1]] = object;
    });
  }

  void attemptMove(List<int> cords) {
    // col, row
    var map = Provider.of<GameScreenProvider>(context, listen: false).map;
    if ((playerCords[0] + 1 == cords[0] ||
            playerCords[0] - 1 == cords[0] ||
            playerCords[0] == cords[0]) &&
        !_game.enemyAlive) {
      if (playerCords[1] + 1 == cords[1] ||
          playerCords[1] - 1 == cords[1] ||
          playerCords[1] == cords[1]) {
        if (map[cords[0]][cords[1]] == MapObject.none) {
          setMapObject(cords, MapObject.player, oldCords: playerCords);
          playerCords = cords;
        } else if (map[cords[0]][cords[1]] == MapObject.preRunShop) {
          showModalBottomSheet(
              context: context,
              builder: (ctx) =>
                  PreRunShopScreen(game: _game, stateSetter: emptyStateSetter));
        } else if (map[cords[0]][cords[1]] == MapObject.dungeonEnterance) {
          setState(() {
            _game.currentFloor = 1;
            enterFloor(_game.currentFloor, map);
            _game.startGame();
          });
        } else if (map[cords[0]][cords[1]] == MapObject.enemy) {
          _game.currentEnemyCords = [cords[0], cords[1]];
          spawnEnemy();
        } else if (map[cords[0]][cords[1]] == MapObject.treasure) {
          spawnTreasure([cords[0], cords[1]]);
        } else if (map[cords[0]][cords[1]] == MapObject.shop) {
          spawnShop([cords[0], cords[1]]);
        } else if (map[cords[0]][cords[1]] == MapObject.floorLadder) {
          _game.currentFloor++;
          enterFloor(_game.currentFloor, map);
        }
      }
    }
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
    context.read<GameScreenProvider>().setUpMap();
    inputs = [];
    playerCords = [2, 4];
    setMapObject(playerCords, MapObject.player);
    setMapObject([2, 0], MapObject.dungeonEnterance);
    setMapObject([1, 2], MapObject.preRunShop);
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

                mapIcon = Icons.error;

                if (map[col][row] == MapObject.none) {
                  mapIcon = null;
                } else if (map[col][row] == MapObject.enemy) {
                  mapIcon = Icons.dangerous;
                } else if (map[col][row] == MapObject.player) {
                  mapIcon = Icons.arrow_downward_outlined;
                } else if (map[col][row] == MapObject.dungeonEnterance) {
                  mapIcon = Icons.door_sliding_outlined;
                } else if (map[col][row] == MapObject.preRunShop) {
                  mapIcon = Icons.shopping_cart_outlined;
                } else if (map[col][row] == MapObject.shop) {
                  mapIcon = Icons.store;
                } else if (map[col][row] == MapObject.floorLadder) {
                  mapIcon = Icons.keyboard_double_arrow_up_sharp;
                } else if (map[col][row] == MapObject.treasure) {
                  mapIcon = Icons.diamond_outlined;
                }

                return Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          attemptMove([col, row]);
                        },
                        child: Icon(mapIcon)),
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
