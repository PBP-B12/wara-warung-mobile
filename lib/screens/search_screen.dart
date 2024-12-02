import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      backgroundColor: Color(0xFFFFFBF2),
      body: Center(
        child: SearchMenu(),
      ),
    );
  }
}

class SearchMenu extends StatefulWidget {
  @override
  _SearchMenuState createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  // Variabel untuk menyimpan pilihan budget
  String? _selectedBudget = 'Budget';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text(
            'Search Menu',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'What do you want to eat?',
            style: GoogleFonts.poppins(fontSize: 25),
          ),
          SizedBox(height: 30),

          // Row untuk search box dan dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search TextField
              Container(
                width: MediaQuery.of(context).size.width *
                    0.6, // Lebar 50% dari layar
                height: 50, // Tinggi fixed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50),
                  ),
                ),
                child: TextField(
                  textAlignVertical: TextAlignVertical
                      .center, // Menjaga teks berada di tengah secara vertikal
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.red),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 18), // Padded untuk rata tengah
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                  width: 0), // Spasi minimal untuk menghubungkan kedua elemen

              // Dropdown button
              Container(
                width: MediaQuery.of(context).size.width *
                    0.2, // Lebar 40% dari layar
                height: 50, // Tinggi fixed sama dengan search box
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(50),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBudget,
                    items: <String>[
                      'Budget',
                      'Up to 10,000',
                      'Up to 20,000',
                      'Up to 30,000'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBudget = newValue;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
