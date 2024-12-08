import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/menuplanning.dart';
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
    final response = await request.get('https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menu/json/');
    // final response = await request.get('http://127.0.0.1:8000/menu/json/');
    var data = response;
    List<Menu> listMenu = [];
    for (var d in data) {
      if (d != null) {
        listMenu.add(Menu.fromJson(d));
      }
    }
    listMenu.shuffle();
    return listMenu.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final request = context.watch<CookieRequest>();

   return Scaffold(
      appBar: Navbar(),
      bottomNavigationBar: const BottomNavbar(),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFFFFBF2)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section with fixed height
              Stack(
                children: [
                  // Orange Gradient Background
                  Container(
                    width: double.infinity,
                    height: 130, // Fixed height for all devices
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFFFF7124), Color(0xFFFFAA7D)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(33),
                        bottomRight: Radius.circular(33),
                      ),
                    ),
                  ),
                  // Profile Avatar and Welcome Text
                  Positioned(
                    top: 25, // Fixed vertical position
                    left: 20, // Fixed left margin
                    right: 20, // Fixed right margin
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40, // Fixed size for avatar
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                        ),
                        const SizedBox(width: 15), // Fixed spacing
                        Expanded(
                          child: Text(
                            'Hello, ${username.isEmpty ? 'Guest' : username[0].toUpperCase() + username.substring(1).toLowerCase()}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 20, // Fixed font size
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.08, top: screenHeight * 0.02),
                child: Text(
                  'What do you want to do today?',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              // Options Section
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.15, // Smaller padding to move closer to the left
                    top: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align options to the start
                  children: [
                    // Option 1: Search Menu
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchScreen()),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/search.png',
                            width: screenWidth * 0.2, // Reduced size for compact layout
                            height: screenWidth * 0.15,
                          ),
                          const SizedBox(height: 6), // Less space between image and text
                          Text(
                            'Search Menu',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03), // Reduced spacing between options
                    // Option 2: Rate & Review
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MenuPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/review.png',
                            width: screenWidth * 0.2, // Reduced size for compact layout
                            height: screenWidth * 0.15,
                          ),
                          const SizedBox(height: 6), // Less space between image and text
                          Text(
                            'Rate & Review',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03), // Reduced spacing between options
                    // Option 3: Menu Planning
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MenuPlanningPage()),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/plan.png',
                            width: screenWidth * 0.2, // Reduced size for compact layout
                            height: screenWidth * 0.15,
                          ),
                          const SizedBox(height: 6), // Less space between image and text
                          Text(
                            'Menu Planning',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.08, top: screenHeight * 0.04),
                child: Text(
                  'Menu Recommendations',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Menu Recommendations Section with FutureBuilder
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.15, top: screenHeight * 0.02),
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
                      return Wrap(
                        spacing: screenWidth * 0.05,
                        runSpacing: screenHeight * 0.02,
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
      ),
    );
  }
}
