import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/models/search.dart';
import 'package:wara_warung_mobile/screens/all_menu.dart';
import 'package:wara_warung_mobile/screens/menuplanning.dart';
import 'package:wara_warung_mobile/screens/ratereview_menu.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';
import 'package:wara_warung_mobile/widgets/bottomnavbar.dart';
import 'package:wara_warung_mobile/widgets/menucardv2.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Result>> fetchRandomMenus(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/menu/json-flutter');
    List<Result> listMenu = [];

    listMenu = Search.fromJson(response).results;
    listMenu.shuffle();
    return listMenu.take(4).toList();
  }

  int getCrossAxisCount(double width) {
    if (width >= 1280) {
      return 5;
    } else if (width >= 1024) {
      return 4;
    } else if (width >= 768) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = getCrossAxisCount(MediaQuery.of(context).size.width);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final request = context.watch<CookieRequest>();
    final username = request.getJsonData()['username'] ?? "";

    return Scaffold(
      appBar: Navbar(),
      bottomNavigationBar: BottomNavbar(),
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
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: 15), // Fixed spacing
                        Expanded(
                          child: Text(
                            'Hello, ${username.isEmpty ? 'Guest' : username[0].toUpperCase() + username.substring(1).toLowerCase()}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 25,
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
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Makes buttons align evenly
                  children: [
                    // Option 1: Search Menu
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/search.png',
                              width: screenWidth *
                                  0.25, // Adjusted size for a larger button
                              height: screenWidth * 0.18,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Search Menu',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize:
                                    screenWidth * 0.035, // Larger font size
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth * 0.01), // Spacing between options

                    // Option 2: Rate & Review
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllMenu()),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/review.png',
                              width: screenWidth *
                                  0.25, // Adjusted size for a larger button
                              height: screenWidth * 0.18,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Rate & Review',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize:
                                    screenWidth * 0.035, // Larger font size
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth * 0.01), // Spacing between options

                    // Option 3: Menu Planning
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuPlanningPage()),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/plan.png',
                              width: screenWidth *
                                  0.25, // Adjusted size for a larger button
                              height: screenWidth * 0.18,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Menu Planning',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize:
                                    screenWidth * 0.035, // Larger font size
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
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
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: FutureBuilder<List<Result>>(
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
                      return GridView.builder(
                        shrinkWrap:
                            true, // Makes the GridView scrollable within the SingleChildScrollView
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio: username != "" ? screenWidth * 0.0013 : screenWidth * 0.00159,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var menu = snapshot.data![index];
                          return MenuCard(
                            title: menu.menu,
                            price: menu.harga,
                            imageUrl: menu.gambar,
                            warung: menu.warung,
                            idMenu: menu.id,
                            avgRating: menu.avgRating,
                            request: request,
                            context: context,
                          );
                        },
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
