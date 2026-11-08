import 'package:flutter/material.dart';

import '../config.dart';
import '../data/hajj.dart';
import '../data/namaz_rules.dart';
import '../utils/launch.dart';
import '../widgets/credit.dart';
import '../widgets/sections.dart';
import 'calendar_page.dart';
import 'dua_page.dart';
import 'names_page.dart';
import 'prophets_page.dart';
import 'qibla_page.dart';
import 'quiz_page.dart';
import 'zakat_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  void _go(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.mosque, 'নামাজের নিয়ম',
          () => _go(context, const SectionsPage(title: 'নামাজের নিয়ম', items: namazRules))),
      (Icons.person, 'নবী-রাসুলদের জীবনী', () => _go(context, const ProphetsPage())),
      (Icons.favorite, 'দোয়া', () => _go(context, const DuaPage())),
      (Icons.explore, 'কিবলা কম্পাস', () => _go(context, const QiblaPage())),
      (Icons.location_on, 'কাছের মসজিদ',
          () => openUrl(context, 'https://www.google.com/maps/search/mosque+near+me')),
      (Icons.calculate, 'যাকাত ক্যালকুলেটর', () => _go(context, const ZakatPage())),
      (Icons.calendar_month, 'ইসলামিক ক্যালেন্ডার',
          () => _go(context, const CalendarPage())),
      (Icons.auto_awesome, 'আল্লাহর ৯৯ নাম', () => _go(context, const NamesPage())),
      (Icons.flight, 'হজ ও উমরাহ গাইড',
          () => _go(context, const SectionsPage(title: 'হজ ও উমরাহ', items: hajjGuide))),
      (Icons.quiz, 'ইসলামিক কুইজ', () => _go(context, const QuizPage())),
      (Icons.live_tv, 'লাইভ মক্কা',
          () => openUrl(context, AppConfig.liveMakkahUrl)),
      (Icons.live_tv, 'লাইভ মদিনা',
          () => openUrl(context, AppConfig.liveMadinahUrl)),
      (Icons.question_answer, 'আলেমদের প্রশ্ন করুন (ইমেইল)',
          () => openUrl(context,
              'mailto:${AppConfig.scholarEmail}?subject=${Uri.encodeComponent('ইসলামিক প্রশ্ন')}')),
      (Icons.call, 'মুফতির সাথে কথা বলুন',
          () => openUrl(context, 'tel:${AppConfig.muftiPhone}')),
    ];

    return ListView(
      children: [
        for (final it in items)
          ListTile(
            leading: Icon(it.$1),
            title: Text(it.$2),
            trailing: const Icon(Icons.chevron_right),
            onTap: it.$3,
          ),
        const CreditFooter(),
      ],
    );
  }
}
