enum AllPreRunBuffes { moreBread, instaLevels }

class PreRunShopItem {
  PreRunShopItem(
      {required this.name,
      required this.description,
      required this.gemPrice,
      required this.buffGiven});

  final String name;
  final String description;
  final int gemPrice;
  final AllPreRunBuffes buffGiven;
}

Map<AllPreRunBuffes, PreRunShopItem> preRunShop = {
  AllPreRunBuffes.moreBread: PreRunShopItem(
      name: 'Ekstra Ekmek',
      description:
          'Açlık çok büyük bir sıkıntıdır. 5 ekstra ekmek ile onu yenme işin kolaylaşır.',
      gemPrice: 3,
      buffGiven: AllPreRunBuffes.moreBread),
  AllPreRunBuffes.instaLevels: PreRunShopItem(
      name: 'Hızlı Seviye',
      description:
          'Seviye kazanmak zordur. Bunu alarak ise seviye 3\'ten başla',
      gemPrice: 10,
      buffGiven: AllPreRunBuffes.instaLevels)
};
