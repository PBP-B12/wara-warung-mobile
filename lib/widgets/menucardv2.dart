import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  final int price;
  final String imageUrl;
  final String warung;

  const MenuCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.warung,
  });

  @override
  Widget build(BuildContext context) {
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
                image: DecorationImage(
                  image: NetworkImage(imageUrl), // Gambar menu dari URL
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Rp ${price.toString()}', // Mengonversi harga menjadi string
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Available at:\n$warung',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
