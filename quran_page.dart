import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late Future<List<dynamic>> _future = _fetch();
  int? _lastRead;

  @override
  void initState() {
    super.initState();
    _loadLast();
  }

  Future<void> _loadLast() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) setState(() => _lastRead = p.getInt('last_surah'));
  }

  Future<List<dynamic>> _fetch() async {
    final r = await http.get(Uri.parse('${AppConfig.quranApi}/surah'));
    if (r.statusCode != 200) throw Exception('Quran list load failed');
    return jsonDecode(r.body)['data'] as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ইন্টারনেট সংযোগ দেখুন'),
                TextButton(
                  onPressed: () => setState(() => _future = _fetch()),
                  child: const Text('আবার চেষ্টা করুন'),
                ),
              ],
            ),
          );
        }
        final list = snap.data!;
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final s = list[i] as Map<String, dynamic>;
            final n = s['number'] as int;
            return ListTile(
              leading: CircleAvatar(child: Text('$n')),
              title: Text('${s['englishName']}'),
              subtitle: Text(
                  '${s['englishNameTranslation']} · ${s['numberOfAyahs']} আয়াত'),
              trailing: Text('${s['name']}',
                  style: const TextStyle(fontSize: 18)),
              selected: _lastRead == n,
              onTap: () async {
                final p = await SharedPreferences.getInstance();
                await p.setInt('last_surah', n);
                if (!context.mounted) return;
                setState(() => _lastRead = n);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SurahPage(number: n, title: '${s['englishName']}'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SurahPage extends StatefulWidget {
  final int number;
  final String title;
  const SurahPage({super.key, required this.number, required this.title});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final Future<List<List<dynamic>>> _future = _fetch();

  Future<List<List<dynamic>>> _fetch() async {
    final url =
        '${AppConfig.quranApi}/surah/${widget.number}/editions/${AppConfig.quranEditions}';
    final r = await http.get(Uri.parse(url));
    if (r.statusCode != 200) throw Exception('Surah load failed');
    final data = jsonDecode(r.body)['data'] as List<dynamic>;
    return [
      data[0]['ayahs'] as List<dynamic>,
      data[1]['ayahs'] as List<dynamic>,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.number}. ${widget.title}')),
      body: FutureBuilder<List<List<dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return const Center(child: Text('লোড করা যায়নি। ইন্টারনেট দেখুন।'));
          }
          final ar = snap.data![0];
          final bn = snap.data![1];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ar.length,
            separatorBuilder: (_, __) => const Divider(height: 28),
            itemBuilder: (context, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${ar[i]['numberInSurah']}',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      '${ar[i]['text']}',
                      style: const TextStyle(fontSize: 26, height: 1.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${bn[i]['text']}',
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
