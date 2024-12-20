import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';
import '../screens/add_menu_screen.dart';
import 'package:wara_warung_mobile/screens/logind.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String username;

  Navbar({Key? key, this.username = "guest"})
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
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => MenuDrawer(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final username = request.getJsonData()['username'];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Menggunakan Center untuk memastikan teks berada di tengah
          ListTile(
            title: Center(
              child: Text(
                'Home',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
            onTap: () {
              Navigator.canPop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: Center(
              child: Text(
                'Search',
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
            onTap: () {
              Navigator.canPop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          if (username != null)
            ListTile(
              title: Center(
                child: Text(
                  'Menu Planning',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.canPop(context); // Kembali ke Search Screen
              },
            ),
          if (username != null)
            ListTile(
              title: Center(
                child: Text(
                  'My Account',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.canPop(context); // Kembali ke Search Screen
              },
            ),
          if (username == "admin")
            ListTile(
              title: Center(
                child: Text(
                  'Add Menu',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.canPop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewMenuScreen()),
                );
              },
            ),
          SizedBox(height: 16),
          if (username == null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false, // Menghapus semua route sebelumnya
                );
              },
              child: Text('Log In',
                  style: GoogleFonts.poppins(color: Colors.black)),
            ),
          if (username != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final response =
                    await request.logout("http://127.0.0.1:8000/auth/logoutd/");
                String message = response["message"];
                if (context.mounted) {
                  if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message Sampai jumpa, $uname."),
                    ));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false, // Menghapus semua route sebelumnya
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  }
                }
              },
              child: Text('Log Out',
                  style: GoogleFonts.poppins(color: Colors.black)),
            ),
        ],
      ),
    );
  }
}
