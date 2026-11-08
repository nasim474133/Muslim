import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _bearing;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() => _error = 'লোকেশনের অনুমতি দিন');
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
      setState(() => _bearing = _qiblaBearing(p.latitude, p.longitude));
    } catch (_) {
      setState(() => _error = 'লোকেশন পাওয়া যায়নি');
    }
  }

  /// Initial great-circle bearing from the user to the Kaaba, in degrees.
  double _qiblaBearing(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;
    final phi1 = lat * math.pi / 180;
    final phi2 = kaabaLat * math.pi / 180;
    final dLon = (kaabaLon - lon) * math.pi / 180;
    final y = math.sin(dLon) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('কিবলা কম্পাস')),
      body: Center(
        child: _error != null
            ? Text(_error!)
            : _bearing == null
                ? const CircularProgressIndicator()
                : StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (context, snap) {
                      final heading = snap.data?.heading;
                      if (heading == null) {
                        return const Text('কম্পাস সেন্সর পাওয়া যায়নি');
                      }
                      final angle = (_bearing! - heading) * math.pi / 180;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: angle,
                            child: Icon(
                              Icons.navigation,
                              size: 180,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('কিবলা: ${_bearing!.toStringAsFixed(0)}° (উত্তর থেকে)'),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'তীর যেদিকে দেখাচ্ছে সেটাই কিবলার দিক। ফোন সমতল রাখুন এবং ধাতব বস্তু থেকে দূরে রাখুন।',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
