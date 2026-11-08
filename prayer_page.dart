import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../services/notification_service.dart';
import '../widgets/credit.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  static const _names = {
    Prayer.fajr: 'ফজর',
    Prayer.sunrise: 'সূর্যোদয়',
    Prayer.dhuhr: 'যোহর',
    Prayer.asr: 'আসর',
    Prayer.maghrib: 'মাগরিব',
    Prayer.isha: 'এশা',
  };

  Coordinates _coords = Coordinates(23.8103, 90.4125); // Dhaka fallback
  String _place = 'ঢাকা (ডিফল্ট)';
  PrayerTimes? _times;
  Prayer _next = Prayer.none;
  Duration? _left;
  int _day = DateTime.now().day;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Position?> _getPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _load() async {
    final pos = await _getPosition();
    if (pos != null) {
      _coords = Coordinates(pos.latitude, pos.longitude);
      _place = 'আপনার বর্তমান অবস্থান';
    }
    _compute();
  }

  void _compute() {
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    final t = PrayerTimes.today(_coords, params);
    if (!mounted) return;
    setState(() {
      _times = t;
      _day = DateTime.now().day;
    });
    _schedule(t);
    _tick();
  }

  Future<void> _schedule(PrayerTimes t) async {
    try {
      await NotificationService.schedulePrayers(t);
    } catch (_) {}
  }

  void _tick() {
    final t = _times;
    if (t == null || !mounted) return;
    if (DateTime.now().day != _day) {
      _compute();
      return;
    }
    final next = t.nextPrayer();
    final at = next == Prayer.none ? null : t.timeForPrayer(next);
    setState(() {
      _next = next;
      _left = at?.difference(DateTime.now());
    });
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final t = _times;
    if (t == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final time = DateFormat('hh:mm a');
    final rows = <(Prayer, DateTime)>[
      (Prayer.fajr, t.fajr),
      (Prayer.sunrise, t.sunrise),
      (Prayer.dhuhr, t.dhuhr),
      (Prayer.asr, t.asr),
      (Prayer.maghrib, t.maghrib),
      (Prayer.isha, t.isha),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(_place, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                if (_left != null) ...[
                  Text('পরবর্তী: ${_names[_next]}',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(_fmt(_left!),
                      style: Theme.of(context).textTheme.displaySmall),
                ] else
                  Text('আজকের নামাজের ওয়াক্ত শেষ',
                      style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final r in rows)
          Card(
            shape: r.$1 == _next
                ? RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: ListTile(
              title: Text(_names[r.$1]!),
              trailing: Text(time.format(r.$2),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          'হিসাব: কারাচি পদ্ধতি, হানাফি আসর। আজান নোটিফিকেশন প্রতিদিন অ্যাপ খুললে নতুন করে সেট হয়।',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const CreditFooter(),
      ],
    );
  }
}
