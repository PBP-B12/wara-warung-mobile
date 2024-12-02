import 'package:flutter/material.dart';
import 'package:wara_warung_mobile/homepage.dart';
import 'package:wara_warung_mobile/startmenu.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const WaraWarungApp());
}

class WaraWarungApp extends StatelessWidget {
  const WaraWarungApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wara Warung',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.orange, // Ungu kustom
          secondary: Colors.red, // Ungu elemen sekunder
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartMenu(), // StartMenu is the initial screen
        '/home': (context) => const HomePage(), // HomePage is the second screen
      },
    );
  }
}
