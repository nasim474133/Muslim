import 'package:flutter/material.dart';

import '../data/names99.dart';
import '../widgets/credit.dart';

class NamesPage extends StatelessWidget {
  const NamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আল্লাহর ৯৯ নাম')),
      body: ListView.builder(
        itemCount: names99.length + 1,
        itemBuilder: (context, i) {
          if (i == names99.length) return const CreditFooter();
          final n = names99[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text(n.$2),
            subtitle: Text(n.$3),
            trailing: Text(n.$1, style: const TextStyle(fontSize: 22)),
          );
        },
      ),
    );
  }
}
