import 'package:flutter/material.dart';
import 'credit.dart';

/// A scrollable list of expandable (title, body) sections.
class ContentSections extends StatelessWidget {
  final List<(String, String)> items;
  final String? note;
  const ContentSections({super.key, required this.items, this.note});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(note!, style: Theme.of(context).textTheme.bodySmall),
          ),
        for (final it in items)
          Card(
            child: ExpansionTile(
              title: Text(it.$1),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(it.$2, style: const TextStyle(fontSize: 16, height: 1.6)),
              ],
            ),
          ),
        const CreditFooter(),
      ],
    );
  }
}

class SectionsPage extends StatelessWidget {
  final String title;
  final List<(String, String)> items;
  final String? note;
  const SectionsPage(
      {super.key, required this.title, required this.items, this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ContentSections(items: items, note: note),
    );
  }
}
