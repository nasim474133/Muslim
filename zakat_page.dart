import 'package:flutter/material.dart';

import '../widgets/credit.dart';

class ZakatPage extends StatefulWidget {
  const ZakatPage({super.key});

  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  final _c = <String, TextEditingController>{
    'cash': TextEditingController(),
    'gold': TextEditingController(),
    'silver': TextEditingController(),
    'business': TextEditingController(),
    'other': TextEditingController(),
    'debt': TextEditingController(),
    'silverPrice': TextEditingController(),
  };

  double _v(String k) => double.tryParse(_c[k]!.text.trim()) ?? 0;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(String key, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: _c[key],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration:
              InputDecoration(labelText: label, border: const OutlineInputBorder()),
          onChanged: (_) => setState(() {}),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final total = _v('cash') +
        _v('gold') +
        _v('silver') +
        _v('business') +
        _v('other') -
        _v('debt');
    // Nisab (silver standard): 52.5 tola silver = about 612.36 grams.
    // The user enters today's price per gram so the nisab value is current.
    final nisab = 612.36 * _v('silverPrice');
    final hasNisab = nisab > 0;
    final due = hasNisab && total >= nisab;

    return Scaffold(
      appBar: AppBar(title: const Text('যাকাত ক্যালকুলেটর')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
              'সব অঙ্ক টাকায় লিখুন। যাকাত ফরজ হয় যখন এক বছর পূর্ণ হওয়া সম্পদ নিসাবের সমান বা বেশি হয়।'),
          const SizedBox(height: 12),
          _field('silverPrice', 'আজকের রূপার দাম (প্রতি গ্রাম, টাকা)'),
          _field('cash', 'নগদ টাকা ও ব্যাংক জমা'),
          _field('gold', 'স্বর্ণের বর্তমান মূল্য'),
          _field('silver', 'রূপার বর্তমান মূল্য'),
          _field('business', 'ব্যবসায়িক পণ্যের মূল্য'),
          _field('other', 'অন্যান্য প্রাপ্য/বিনিয়োগ'),
          _field('debt', 'বাদ দেওয়ার মতো ঋণ'),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('মোট যাকাতযোগ্য সম্পদ: ${total.toStringAsFixed(2)}'),
                  if (hasNisab)
                    Text('নিসাব (৫২.৫ তোলা রূপা): ${nisab.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text(
                    !hasNisab
                        ? 'রূপার দাম দিলে নিসাব হিসাব হবে'
                        : due
                            ? 'আপনার যাকাত: ${(total * 0.025).toStringAsFixed(2)} টাকা (২.৫%)'
                            : 'আপনার সম্পদ নিসাবের কম, যাকাত ফরজ নয়',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'এটি সাধারণ হিসাব। জটিল ক্ষেত্রে আলেমের পরামর্শ নিন।',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const CreditFooter(),
        ],
      ),
    );
  }
}
