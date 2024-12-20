import 'package:flutter/material.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0xFFFFFBF2),
        child: Stack(
          children: [
            // Orange gradient oval background
            Positioned(
              left: -screenWidth * 0.3,
              top: screenHeight * 0.55,
              child: Container(
                width: screenWidth * 1.6,
                height: screenHeight * 0.8,
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, 1.0),
                    colors: [Color(0xFFFF6E1F), Color(0xFFFF8442)],
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),

            // Background illustration (center)
            Positioned(
              left: 0,
              top: screenHeight * 0.3,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/startmenu.png'), // Use AssetImage
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Logo
            Positioned(
              top: screenHeight * 0.06,
              left: (screenWidth - screenWidth * 0.12) / 2,
              child: Container(
                width: screenWidth * 0.12,
                height: screenHeight * 0.08,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Title (WaraWarung)
            Positioned(
              top: screenHeight * 0.15,
              width: screenWidth,
              child: const Text(
                'WaraWarung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF6700),
                  fontSize: 35,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Subtitle
            Positioned(
              top: screenHeight * 0.25,
              width: screenWidth,
              child: const Text(
                'Find food, read reviews, \nand personalize your chosen menu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF120400),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Start button
            Positioned(
              bottom: screenHeight * 0.15,
              left: (screenWidth - screenWidth * 0.6) / 2,
              child: GestureDetector(
                onTap: () {
                  // Navigate to the next page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.08,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Start',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
