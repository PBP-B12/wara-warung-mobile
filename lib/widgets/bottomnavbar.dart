import 'package:flutter/material.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';
import 'package:wara_warung_mobile/screens/user_dashboard.dart';

class BottomNavbar extends StatelessWidget {
  final String username;
  const BottomNavbar({super.key, this.username = "guest"});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Height of the bottom navbar
      decoration: BoxDecoration(
        color: const Color(0xFFFF7428),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          if (username != "guest" && username != "")
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboard()),
                );
              },
              icon: const Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
