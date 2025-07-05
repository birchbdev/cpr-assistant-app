import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/cpr_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const CPRApp());
}

class CPRApp extends StatelessWidget {
  const CPRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPR Assistant',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cpr': (context) => const CPRScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
