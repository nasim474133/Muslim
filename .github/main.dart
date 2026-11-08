import 'package:flutter/material.dart';

import 'config.dart';
import 'pages/hadith_page.dart';
import 'pages/more_page.dart';
import 'pages/prayer_page.dart';
import 'pages/quran_page.dart';
import 'pages/tasbih_page.dart';
import 'services/notification_service.dart';
import 'widgets/credit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.init();
  } catch (_) {
    // App still works without notifications.
  }
  runApp(const IslamicApp());
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0B6E4F),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['নামাজের সময়', 'আল-কুরআন', 'হাদিস', 'তসবিহ', 'আরও'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAbout(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          PrayerPage(),
          QuranPage(),
          HadithPage(),
          TasbihPage(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.access_time), label: 'নামাজ'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'কুরআন'),
          NavigationDestination(icon: Icon(Icons.library_books), label: 'হাদিস'),
          NavigationDestination(icon: Icon(Icons.touch_app), label: 'তসবিহ'),
          NavigationDestination(icon: Icon(Icons.apps), label: 'আরও'),
        ],
      ),
    );
  }
}
