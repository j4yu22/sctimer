import 'package:flutter/material.dart';
import 'home_page/home.dart';
import '../settings_page/settings.dart';
import '../stats_page/stats.dart';
import '../graphs_page/graphs.dart';
import '../times_page/times.dart';
import '../data/database_helper.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/times': (context) => const TimesPage(),
        '/graphs': (context) => const GraphsPage(),
        '/stats': (context) => const StatsPage(),
        '/settings': (context) => const SettingsPage(),
      },
      initialRoute: '/',
    );
  }
}
