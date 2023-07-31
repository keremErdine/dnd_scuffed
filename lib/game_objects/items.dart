import 'package:dnd_scuffed/game.dart';

class Item {
  Item({
    required this.name,
    required this.description,
    required this.itemAction,
    required this.itemID,
  });
  final ItemIDs itemID;
  final String name;
  final String description;
  final void Function(Game) itemAction;
}

enum ItemIDs {
  tester,
  smallHealthPotion,
  bread,
  pie,
  mediumHealthPotion,
  largeHealthPotion,
  totemOfUndying,
  invisibilityPotion,
  teleporter,
  totemOfMadness,
  woodKey,
  ironKey,
  goldKey,
  diamondKey,
  ancientKey,
  doubleEdgesHorn
}

Map<ItemIDs, Item> items = {
  ItemIDs.tester: Item(
    itemID: ItemIDs.tester,
    name: 'tester',
    description: 'E',
    itemAction: (game) {
      game.addMessage('amogus');
    },
  ),
  ItemIDs.smallHealthPotion: Item(
    itemID: ItemIDs.smallHealthPotion,
    name: 'Küçük Sağlık İksiri',
    description: 'Küçük bir sağlık iksiri. İçerek 15 sağlık puanı kazan.',
    itemAction: (game) {
      game.player.heal(15);
    },
  ),
  ItemIDs.bread: Item(
    itemID: ItemIDs.bread,
    name: 'Ekmek',
    description: 'Bildiğin ekmek işte. Yiyerek 15 açlık puanı kazan.',
    itemAction: (game) {
      game.player.restoreHunger(15);
    },
  ),
  ItemIDs.pie: Item(
    itemID: ItemIDs.pie,
    name: 'Turta',
    description: 'Tadı güzel bir turta. Yiyerek 25 açlık puanı kazan.',
    itemAction: (game) {
      game.player.restoreHunger(25);
    },
  ),
  ItemIDs.mediumHealthPotion: Item(
    itemID: ItemIDs.mediumHealthPotion,
    name: 'Sağlık İksiri',
    description: 'Asıl boyutu bu olsa gerek. İçerek 25 sağlık puanı kazan.',
    itemAction: (game) {
      game.player.heal(25);
    },
  ),
  ItemIDs.largeHealthPotion: Item(
    itemID: ItemIDs.largeHealthPotion,
    name: 'Büyük Sağlık İksiri',
    description: 'Hakikaten büyükmüş. İçerek 45 sağlık puanı kazan.',
    itemAction: (game) {
      game.player.heal(45);
    },
  ),
  ItemIDs.totemOfUndying: Item(
    itemID: ItemIDs.totemOfUndying,
    name: 'Ölümsüzlük Totemi',
    description:
        'Efsanelerdeki şey gerçekmiş. Seni bir kereliğine bile olsa ölümden kurtarır.',
    itemAction: (game) {
      game.addMessage('Bir işe yaramadı.');
      game.player.inventory[ItemIDs.totemOfUndying] =
          game.player.inventory[ItemIDs.totemOfUndying]! + 1;
    },
  ),
  ItemIDs.invisibilityPotion: Item(
    itemID: ItemIDs.invisibilityPotion,
    name: 'Görünmezlik İksiri',
    description: 'Beni göremezsin. İç ve bir turluğuna rakibinden kaçın.',
    itemAction: (game) {
      game.activeBuffes.add(Buff.invisible);
    },
  ),
  ItemIDs.teleporter: Item(
    itemID: ItemIDs.teleporter,
    name: 'Işınlayıcı',
    description:
        'Bye. Açlık masrafı olmadan kaç. Kaçtığın zaman otomatik çalışır.',
    itemAction: (game) {
      game.addMessage(
          'Bir işe yaramadı. Unutma: Kaçtığın zaman zaten çalışacak!');
      game.player.inventory[ItemIDs.teleporter] =
          game.player.inventory[ItemIDs.teleporter]! + 1;
    },
  ),
  ItemIDs.totemOfMadness: Item(
    itemID: ItemIDs.totemOfMadness,
    name: 'Delilik Totemi',
    description: 'HAARGGH! Delir ve hasarını bir turluğuna 5 katına çıkar.',
    itemAction: (game) {
      game.activeBuffes.add(Buff.mad);
      game.player.damageMultiplier = 5;
      game.addMessage(
          'HAAAAAAAARGH! ÇOK KIZGINIM! Hasarın bir turluğuna 5 katına çıktı!');
    },
  ),
  ItemIDs.woodKey: Item(
    itemID: ItemIDs.woodKey,
    name: 'Tahta Anahtar',
    description: 'Tahta bir sandığı açabilir.',
    itemAction: (game) {
      game.addMessage('Ne bekliyordun?');
      game.player.inventory[ItemIDs.woodKey] =
          game.player.inventory[ItemIDs.woodKey]! + 1;
    },
  ),
  ItemIDs.ironKey: Item(
    itemID: ItemIDs.ironKey,
    name: 'Demir Anahtar',
    description: 'Demir bir sandığı açabilir.',
    itemAction: (game) {
      game.addMessage('Ne bekliyordun?');
      game.player.inventory[ItemIDs.ironKey] =
          game.player.inventory[ItemIDs.ironKey]! + 1;
    },
  ),
  ItemIDs.goldKey: Item(
    itemID: ItemIDs.goldKey,
    name: 'Altın Anahtar',
    description: 'Altın bir sandığı açabilir.',
    itemAction: (game) {
      game.addMessage('Ne bekliyordun?');
      game.player.inventory[ItemIDs.goldKey] =
          game.player.inventory[ItemIDs.goldKey]! + 1;
    },
  ),
  ItemIDs.diamondKey: Item(
    itemID: ItemIDs.diamondKey,
    name: 'Elmas Anahtar',
    description: 'Elmas bir sandığı açabilir.',
    itemAction: (game) {
      game.addMessage('Ne bekliyordun?');
      game.player.inventory[ItemIDs.diamondKey] =
          game.player.inventory[ItemIDs.diamondKey]! + 1;
    },
  ),
  ItemIDs.ancientKey: Item(
    itemID: ItemIDs.ancientKey,
    name: 'Antik Anahtar',
    description: 'Antik bir sandığı açabilir.',
    itemAction: (game) {
      game.addMessage('Ne bekliyordun?');
      game.player.inventory[ItemIDs.ancientKey] =
          game.player.inventory[ItemIDs.ancientKey]! + 1;
    },
  ),
  ItemIDs.doubleEdgesHorn: Item(
      name: 'Çift Uçlu Boynuz',
      description:
          'Saldırı hasarını ve kullanılan açlığı bir turluğuna iki katına çıkar. Dikkatli kullan',
      itemAction: (game) {},
      itemID: ItemIDs.doubleEdgesHorn)
};
