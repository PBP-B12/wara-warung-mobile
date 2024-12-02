import 'package:flutter/material.dart';
import 'bottomnavbar.dart'; // Import the BottomNavbar
import 'menuplanning.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      bottomNavigationBar: const BottomNavbar(), // Place the BottomNavbar here
      body: Stack(
        children: [
          // Orange Gradient Background
          Positioned(
            top: -45,
            left: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.26,
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
            top: screenHeight * 0.07,
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
          // Back Button
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.02,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate back to StartMenu
              },
            ),
          ),
          // Welcome Text
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.15,
            child: SizedBox(
              width: screenWidth * 0.8,
              child: const Text(
                'Hello, Luthfi',
                style: TextStyle(
                  color: Color(0xFF300C00),
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Section Title: What to Do Today
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.25,
            child: SizedBox(
              width: screenWidth * 0.8,
              child: const Text(
                'What do you want to do today?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Option 1: Search Menu
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.29, // Adjusted to make space for the image
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
                const SizedBox(height: 8), // Add space between image and text
                const Text(
                  'Search Menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Option 2: Rate & Review
          Positioned(
            left: screenWidth * 0.4,
            top: screenHeight * 0.29, // Adjusted to make space for the image
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/review.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Add space between image and text
                const Text(
                  'Rate & Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Option 3: Menu Planning
          Positioned(
            left: screenWidth * 0.68,
            top: screenHeight * 0.29, // Adjusted to make space for the image
            child: Column(
              children: [
                GestureDetector(
                onTap: () {
                  // Navigate to the MenuPlanningPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuPlanningPage()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/plan.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 8), // Add space between image and text
                const Text(
                  'Menu Planning',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Section Title: Menu Recommendations
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.43,
            child: SizedBox(
              width: screenWidth * 0.8,
              child: const Text(
                'Menu Recommendations',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Menu Recommendation Cards
          Positioned(
            left: screenWidth * 0.08,
            top: screenHeight * 0.48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildMenuCard(screenWidth, screenHeight, 'Nasi Goreng', 'Rp20.000'),
                SizedBox(width: screenWidth * 0.02),
                buildMenuCard(screenWidth, screenHeight, 'Mie Goreng', 'Rp15.000'),
                SizedBox(width: screenWidth * 0.02),
                buildMenuCard(screenWidth, screenHeight, 'Soto Ayam', 'Rp25.000'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to Build Menu Cards
  Widget buildMenuCard(double screenWidth, double screenHeight, String title, String price) {
    return Container(
      width: screenWidth * 0.27,
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        gradient: const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFF5E6C5), Color(0xFFFFC4A4)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/97x68"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Available at:\nWarung Lestari, Warung Man Luh, ...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 6,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
