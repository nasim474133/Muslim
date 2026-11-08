/// Central place for values you will want to change.
class AppConfig {
  static const appName = 'ইমান আনো';
  static const creditLine = 'Created by Md Nasim Al Mamud';

  // Ask Scholars: questions are sent by email (replace with your address).
  static const scholarEmail = 'your-email@example.com';

  // Voice call to Mufti: replace with the real number.
  static const muftiPhone = '+8801XXXXXXXXX';

  // Live Makkah / Madinah: replace with an official live stream link.
  static const liveMakkahUrl =
      'https://www.youtube.com/results?search_query=makkah+live';
  static const liveMadinahUrl =
      'https://www.youtube.com/results?search_query=madinah+live';

  // Quran data (api.alquran.cloud). Editions: Arabic + Bangla translation.
  static const quranApi = 'https://api.alquran.cloud/v1';
  static const quranEditions = 'quran-uthmani,bn.bengali';

  // Hadith data (fawazahmed0/hadith-api via jsDelivr).
  // Edition ids below are NOT verified. Check editions.json at
  // https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions.json
  // and fix any id that does not exist. Also check each translation's license.
  static const hadithBase =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions';
  static const hadithBooks = <(String, String)>[
    ('সহিহ বুখারি', 'ben-bukhari'),
    ('সহিহ মুসলিম', 'ben-muslim'),
    ('সুনানে আবু দাউদ', 'ben-abudawud'),
    ('জামে তিরমিযি', 'ben-tirmidhi'),
    ('সুনানে নাসায়ি', 'ben-nasai'),
    ('সুনানে ইবনে মাজাহ', 'ben-ibnmajah'),
  ];
}
