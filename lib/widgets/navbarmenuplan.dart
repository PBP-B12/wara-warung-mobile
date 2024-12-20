import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/screens/savedmenu.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';
import '../screens/add_menu_screen.dart';
import 'package:wara_warung_mobile/screens/logind.dart';

class NavbarMenuPlan extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String username;

  NavbarMenuPlan({Key? key, this.username = "guest"})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mengatur shadow di sekitar AppBar menggunakan BoxShadow
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Warna shadow
            offset:
                Offset(4, 4), // Mengatur posisi shadow (horizontal, vertikal)
            blurRadius: 6, // Jarak blur
            spreadRadius: 2, // Mengatur seberapa besar shadow menyebar
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white, // Warna latar belakang AppBar

        elevation:
            0, // Setel elevation ke 0 karena kita menggunakan shadow custom
        leading: Navigator.canPop(context)
            ? BackButton(
                color: Colors.black, // Warna ikon back
                onPressed: () => Navigator.pop(context),
              )
            : const SizedBox(width: 32),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wara',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'Warung',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedMenuPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
