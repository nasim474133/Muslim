import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import '../widgets/credit.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  static const _months = [
    'মুহাররম',
    'সফর',
    'রবিউল আউয়াল',
    'রবিউস সানি',
    'জমাদিউল আউয়াল',
    'জমাদিউস সানি',
    'রজব',
    'শাবান',
    'রমজান',
    'শাওয়াল',
    'জিলকদ',
    'জিলহজ',
  ];

  // (hijri month, day, name)
  static const _events = <(int, int, String)>[
    (1, 1, 'ইসলামি নববর্ষ'),
    (1, 10, 'আশুরা'),
    (3, 12, 'ঈদে মিলাদুন্নবী (সা.) (জন্মদিন)'),
    (7, 27, 'শবে মিরাজ'),
    (8, 15, 'শবে বরাত'),
    (9, 1, 'রমজানের প্রথম রোজা'),
    (9, 27, 'শবে কদর (সম্ভাব্য)'),
    (10, 1, 'ঈদুল ফিতর'),
    (12, 9, 'আরাফার দিন'),
    (12, 10, 'ঈদুল আযহা'),
  ];

  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal('en');
    final h = HijriCalendar.now();
    return Scaffold(
      appBar: AppBar(title: const Text('ইসলামিক ক্যালেন্ডার')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('আজকের হিজরি তারিখ',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text('${h.hDay} ${_months[h.hMonth - 1]}, ${h.hYear} হিজরি',
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('গুরুত্বপূর্ণ দিন', style: Theme.of(context).textTheme.titleMedium),
          for (final e in _events)
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(e.$3),
              subtitle: Text('${e.$2} ${_months[e.$1 - 1]}'),
            ),
          Text(
            'চাঁদ দেখার ওপর নির্ভর করায় বাংলাদেশের তারিখ এক-দুই দিন ভিন্ন হতে পারে।',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const CreditFooter(),
        ],
      ),
    );
  }
}
