import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final String warung;

  const MenuCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.warung,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Margin between cards
      width: screenWidth * 0.27, // Adjust width to 27% of the screen
      height: screenHeight * 0.2, // Adjust height to 20% of the screen
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: screenHeight * 0.1,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Text Section
          Padding(
            padding: const EdgeInsets.all(8.0), // Adjust padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp $price',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      // Ensure the text does not overflow
                      child: Text(
                        warung,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 7,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true, // Allow text wrapping
                        overflow: TextOverflow.clip, // Clip overflowing text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
