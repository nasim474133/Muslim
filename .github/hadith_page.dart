import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

dynamic _parse(String s) => jsonDecode(s);

class HadithPage extends StatelessWidget {
  const HadithPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final b in AppConfig.hadithBooks)
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(b.$1),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HadithBookPage(title: b.$1, edition: b.$2),
              ),
            ),
          ),
      ],
    );
  }
}

class HadithBookPage extends StatefulWidget {
  final String title;
  final String edition;
  const HadithBookPage({super.key, required this.title, required this.edition});

  @override
  State<HadithBookPage> createState() => _HadithBookPageState();
}

class _HadithBookPageState extends State<HadithBookPage> {
  late final Future<List<Map<String, dynamic>>> _future = _fetch();
  String _q = '';

  Future<List<Map<String, dynamic>>> _fetch() async {
    final url = '${AppConfig.hadithBase}/${widget.edition}.min.json';
    final r = await http.get(Uri.parse(url));
    if (r.statusCode != 200) throw Exception('Edition not found');
    final decoded = await compute<String, dynamic>(_parse, r.body);
    return (decoded['hadiths'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'এই বইটি লোড করা যায়নি। ইন্টারনেট দেখুন, অথবা config.dart-এ hadith edition id যাচাই করুন।',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final all = snap.data!;
          final list = _q.isEmpty
              ? all
              : all
                  .where((h) =>
                      '${h['hadithnumber']}' == _q ||
                      '${h['text']}'.contains(_q))
                  .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'হাদিস নম্বর বা শব্দ লিখুন',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _q = v.trim()),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, i) {
                    final h = list[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('হাদিস ${h['hadithnumber']}',
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 6),
                        Text('${h['text']}',
                            style: const TextStyle(fontSize: 16, height: 1.5)),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
