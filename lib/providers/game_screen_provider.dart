import 'package:dnd_scuffed/data_models/player.dart';
import 'package:flutter/material.dart';
import 'package:dnd_scuffed/game.dart';

class GameScreenProvider with ChangeNotifier {
  final List<String> _messages = [
    'Selam! Ben SUGOMABOT v3.0\'ım ve sen HAZIR olunca başlayalım.'
  ];
  final List<List<MapObject>> _gameMap = [];
  bool _isFreeplay = false;

  void setUpMap() {
    for (var x = 0; x < 5; x++) {
      List<MapObject> row = [];
      for (var y = 0; y < 5; y++) {
        row.add(MapObject.none);
      }
      _gameMap.add(row);
    }
  }

  void addMessage(String message) {
    _messages.add(message);
  }

  void clearMessages() {
    _messages.clear();
  }

  void playerHealthChange(PlayerData player, int amount) {
    player.health += amount;
  }

  void enterFreeplay() {
    _isFreeplay = true;
  }

  List<List<MapObject>> get map => _gameMap;
  List<String> get chatLog => _messages;
  bool get isFreeplay => _isFreeplay;
}
