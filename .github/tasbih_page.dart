import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/credit.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  static const _presets = <(String, String)>[
    ('সুবহানাল্লাহ', 'سُبْحَانَ اللَّهِ'),
    ('আলহামদুলিল্লাহ', 'الْحَمْدُ لِلَّهِ'),
    ('আল্লাহু আকবার', 'اللَّهُ أَكْبَرُ'),
    ('লা ইলাহা ইল্লাল্লাহ', 'لَا إِلٰهَ إِلَّا اللَّهُ'),
    ('আস্তাগফিরুল্লাহ', 'أَسْتَغْفِرُ اللَّهَ'),
  ];
  static const _targets = [33, 99, 100, 1000];

  int _preset = 0;
  int _count = 0;
  int _rounds = 0;
  int _target = 33;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _prefs = p;
      _preset = p.getInt('tasbih_preset') ?? 0;
      _count = p.getInt('tasbih_count') ?? 0;
      _rounds = p.getInt('tasbih_rounds') ?? 0;
      _target = p.getInt('tasbih_target') ?? 33;
    });
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    p.setInt('tasbih_preset', _preset);
    p.setInt('tasbih_count', _count);
    p.setInt('tasbih_rounds', _rounds);
    p.setInt('tasbih_target', _target);
  }

  void _tap() {
    setState(() {
      _count++;
      if (_count >= _target) {
        _count = 0;
        _rounds++;
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    });
    _save();
  }

  void _reset() {
    setState(() {
      _count = 0;
      _rounds = 0;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < _presets.length; i++)
              ChoiceChip(
                label: Text(_presets[i].$1),
                selected: _preset == i,
                onSelected: (_) {
                  setState(() {
                    _preset = i;
                    _count = 0;
                  });
                  _save();
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(_presets[_preset].$2,
                style: const TextStyle(fontSize: 30, height: 1.8)),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: _tap,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer,
                border: Border.all(color: scheme.primary, width: 4),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$_count',
                      style: Theme.of(context).textTheme.displayLarge),
                  Text('/ $_target'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: Text('সম্পন্ন রাউন্ড: $_rounds')),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            for (final t in _targets)
              ChoiceChip(
                label: Text('$t'),
                selected: _target == t,
                onSelected: (_) {
                  setState(() {
                    _target = t;
                    _count = 0;
                  });
                  _save();
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: OutlinedButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('রিসেট'),
          ),
        ),
        const CreditFooter(),
      ],
    );
  }
}
