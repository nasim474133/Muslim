import 'package:flutter/material.dart';

import '../widgets/credit.dart';

class DuaPage extends StatelessWidget {
  const DuaPage({super.key});

  // (title, arabic, bangla meaning)
  static const _duas = <(String, String, String)>[
    (
      'ঘুম থেকে উঠে',
      'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      'সমস্ত প্রশংসা আল্লাহর, যিনি আমাদের মৃত্যুর পর জীবিত করেছেন এবং তাঁর কাছেই আমাদের ফিরে যেতে হবে।'
    ),
    (
      'ঘুমানোর আগে',
      'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
      'হে আল্লাহ, তোমার নামেই আমি মরি (ঘুমাই) এবং বাঁচি (জাগি)।'
    ),
    (
      'খাওয়ার আগে',
      'بِسْمِ اللَّهِ',
      'আল্লাহর নামে (শুরু করছি)।'
    ),
    (
      'খাওয়ার পরে',
      'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      'সমস্ত প্রশংসা আল্লাহর, যিনি আমাদের খাইয়েছেন, পান করিয়েছেন এবং মুসলিম বানিয়েছেন।'
    ),
    (
      'ঘর থেকে বের হওয়ার সময়',
      'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      'আল্লাহর নামে, আল্লাহর ওপর ভরসা করলাম। আল্লাহর সাহায্য ছাড়া কোনো উপায় ও শক্তি নেই।'
    ),
    (
      'মসজিদে প্রবেশের সময়',
      'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'হে আল্লাহ, আমার জন্য তোমার রহমতের দরজাগুলো খুলে দাও।'
    ),
    (
      'মসজিদ থেকে বের হওয়ার সময়',
      'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      'হে আল্লাহ, আমি তোমার কাছে তোমার অনুগ্রহ প্রার্থনা করছি।'
    ),
    (
      'দুনিয়া ও আখিরাতের কল্যাণের দোয়া (সূরা বাকারা ২:২০১)',
      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      'হে আমাদের রব, আমাদের দুনিয়াতে কল্যাণ দিন, আখিরাতেও কল্যাণ দিন এবং আমাদের জাহান্নামের আযাব থেকে রক্ষা করুন।'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('দোয়া')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final d in _duas)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.$1, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(d.$2,
                            style: const TextStyle(fontSize: 24, height: 1.9)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(d.$3, style: const TextStyle(fontSize: 15, height: 1.5)),
                  ],
                ),
              ),
            ),
          const CreditFooter(),
        ],
      ),
    );
  }
}
