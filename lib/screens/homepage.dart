import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/screens/list_menu.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';
import 'package:wara_warung_mobile/models/menu.dart';
import 'package:wara_warung_mobile/widgets/menucard.dart';
import 'package:wara_warung_mobile/widgets/bottomnavbar.dart';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, this.username = ""});

  // Fetch random menus from the API
  Future<List<Menu>> fetchRandomMenus(CookieRequest request) async {
    // URL endpoint API
    final response = await request.get('http://127.0.0.1:8000/menu/json/');

    // Melakukan decode response menjadi bentuk json
    var data = response;

    // Mengonversi data json menjadi list menu
    List<Menu> listMenu = [];
    for (var d in data) {
      if (d != null) {
        listMenu.add(Menu.fromJson(d));
      }
    }

    // Mengambil 3 item acak dari list menu
    listMenu.shuffle(); // Acak urutan list
    return listMenu.take(3).toList(); // Ambil 3 item pertama
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final request =
        context.watch<CookieRequest>(); // Mendapatkan request cookie

    return Scaffold(
      appBar: Navbar(),
      bottomNavigationBar: const BottomNavbar(),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Color(0xFFFFFBF2)),
        child: Stack(
          children: [
            // Orange Gradient Background
            Positioned(
              top: -45,
              left: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.2,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFFFF7124), Color(0xFFFFAA7D)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(33),
                  ),
                ),
              ),
            ),
            // Profile Image
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.04,
              child: Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // // Back Button
            // Positioned(
            //   left: screenWidth * 0.08,
            //   top: screenHeight * 0.02,
            //   child: IconButton(
            //     icon: const Icon(Icons.arrow_back, color: Colors.black),
            //     onPressed: () {
            //       Navigator.pop(context); // Navigate back to StartMenu
            //     },
            //   ),
            // ),
            // Welcome Text
            Positioned(
              left: screenWidth * 0.25,
              top: screenHeight * 0.055,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'Hello, ${username.isEmpty ? 'Guest' : username[0].toUpperCase() + username.substring(1).toLowerCase()}',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF300C00),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Section Title: What to Do Today
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.2,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'What do you want to do today?',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Option 1: Search Menu (Tombol yang diubah agar navigasi ke SearchScreen)
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.25,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.28,
                      height: screenWidth * 0.2,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/search.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 8), // Add space between image and text
                    Text(
                      'Search Menu',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Option 2: Rate & Review
            Positioned(
              left: screenWidth * 0.35,
              top: screenHeight * 0.25,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage()),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.28,
                      height: screenWidth * 0.2,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/review.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 8), // Add space between image and text
                    Text(
                      'Rate & Review',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Option 3: Menu Planning
            Positioned(
              left: screenWidth * 0.68,
              top: screenHeight * 0.25, // Adjusted to make space for the image
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/plan.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Add space between image and text
                  Text(
                    'Menu Planning',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Section Title: Menu Recommendations
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.41,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'Menu Recommendations',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Menu Recommendations Section with FutureBuilder
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.41,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Text(
                  'Menu Recommendations',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // FutureBuilder to fetch and display 3 random menu items
            Positioned(
              left: screenWidth * 0.08,
              top: screenHeight * 0.45,
              child: FutureBuilder<List<Menu>>(
                future: fetchRandomMenus(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No menu recommendations available.'));
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: snapshot.data!.map((menu) {
                        return MenuCard(
                          title: menu.fields.menu,
                          price: menu.fields.harga,
                          imageUrl: menu.fields.gambar,
                          warung: menu.fields.warung,
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
