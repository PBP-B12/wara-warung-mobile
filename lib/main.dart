import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/screens/startmenu.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

void main() {
  runApp(const WaraWarungApp());
}

class WaraWarungApp extends StatelessWidget {
  const WaraWarungApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wara Warung',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange).copyWith(
            primary: Colors.orange,
            secondary: Colors.red,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const StartMenu(), // StartMenu is the initial screen
          '/home': (context) =>
              const HomePage(), // HomePage is the second screen
        },
      ),
    );
  }
}