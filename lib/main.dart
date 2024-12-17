import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/screens/startmenu.dart' as screen;
import 'startmenu.dart' as local; // Import the StartMenu file
import 'package:wara_warung_mobile/screens/homepage.dart' as local; // Import the HomePage file
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

void main() {
  runApp(const WaraWarungApp());
  // runApp(const MyApp());
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
          textTheme: GoogleFonts.poppinsTextTheme(), // Biar semua font nya Poppins
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.orange,
            secondary: Colors.red,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const local.StartMenu(), // StartMenu is the initial screen
          '/home': (context) =>
              const local.HomePage(), // HomePage is the second screen
        },
      ),
    );
  }
}
