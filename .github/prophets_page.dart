import 'package:flutter/material.dart';

import '../data/prophets.dart';
import '../widgets/sections.dart';

class ProphetsPage extends StatelessWidget {
  const ProphetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('নবী-রাসুলদের জীবনী'),
          bottom: const TabBar(
            tabs: [Tab(text: 'মুহাম্মাদ (সা.)'), Tab(text: 'অন্য নবীগণ')],
          ),
        ),
        body: const TabBarView(
          children: [
            ContentSections(items: muhammadSeerah),
            ContentSections(
              items: prophets,
              note: 'কুরআনে নাম উল্লেখ থাকা নবীদের সংক্ষিপ্ত জীবনী।',
            ),
          ],
        ),
      ),
    );
  }
}
