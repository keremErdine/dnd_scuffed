import 'package:dnd_scuffed/game.dart';

//TODO: Add mana usage to spell casts.

enum SpellID { smallHeal, mediumHeal, largeHeal, firebolt, icebolt }

class Spell {
  Spell(
      {required this.spellID,
      required this.spellName,
      required this.spellCost,
      required this.spellDescription,
      required this.onCast});
  final SpellID spellID;
  final String spellName;
  final int spellCost;
  final String spellDescription;
  void Function(Game game) onCast;
}

Map<SpellID, Spell> spells = {
  SpellID.smallHeal: Spell(
      spellID: SpellID.smallHeal,
      spellName: 'Küçük İyileştirme',
      spellCost: 15,
      spellDescription:
          'Sağlığını doldurman için ideal bir büyü. Kullanarak 10 sağlık doldur.',
      onCast: ((game) {
        game.addMessage('Biraz daha iyi hissediyorsun.');
        game.player.heal(10);
      })),
  SpellID.mediumHeal: Spell(
      spellID: SpellID.mediumHeal,
      spellName: 'Orta İyileştirme',
      spellCost: 30,
      spellDescription:
          'Sağlığını doldurman için biraz daha ideal bir büyü. Kullanarak 20 sağlık doldur.',
      onCast: ((game) {
        game.addMessage('Daha iyi hissediyorsun.');
        game.player.heal(20);
      })),
  SpellID.largeHeal: Spell(
      spellID: SpellID.largeHeal,
      spellName: 'Büyük İyileştirme',
      spellCost: 55,
      spellDescription:
          'Sağlıklı olmak istiyorsan bunu spamlersin. Kullanarak 35 sağlık doldur.',
      onCast: ((game) {
        game.addMessage('ÇOOOOOOOOOK daha iyi hissediyorsun.');
        game.player.heal(35);
      })),
  SpellID.firebolt: Spell(
      spellID: SpellID.firebolt,
      spellName: 'Ateş Topu',
      spellCost: 20,
      spellDescription:
          'Hasar vermek için güzel bir başlangıç büyüsü. Bu saldırı ile 1.5 kat daha fazla hasar ver.',
      onCast: ((game) {
        if (!game.enemyAlive || game.activeBuffes.contains(Buff.firebolt)) {
          game.addMessage(
              'Büyüyü kullandın ama sadece boşu boşuna mana harcamış oldun. :|');
        } else {
          game.addMessage('Sonraki saldırın için bir ateştopu hazırladın!');
          game.player.damageMultiplier =
              (game.player.damageMultiplier * 1.5).round();
          game.activeBuffes.add(Buff.firebolt);
        }
      }))
};
