import 'package:flutter/material.dart';

class MageScreen extends StatefulWidget {
  const MageScreen({super.key});

  @override
  State<MageScreen> createState() {
    return _MageScreenState();
  }
}

class _MageScreenState extends State<MageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'BÜYÜCÜ',
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          Text(
            'Büyücüler sana rastgele büyü kitapları satar. Eğer o kitabı beğenmediysen mana çıkarımı ile mana kazanabilir ya da birleştirip daha iyi kitaplar elde etme şansını alabilirsin.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.ac_unit_outlined),
                label: const Text('ÖĞREN'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_fix_high_outlined),
                label: const Text('MANA ÇIKARMA'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.library_books_outlined),
                label: const Text('BİRLEŞTİRME'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
