import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wara_warung_mobile/models/search.dart';
import 'package:wara_warung_mobile/widgets/menucardv2.dart';
import '../widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AllMenu extends StatelessWidget {
  const AllMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      backgroundColor: const Color(0xFFFFFBF2),
      body: const SearchMenu(),
    );
  }
}

class SearchMenu extends StatefulWidget {
  const SearchMenu({super.key});

  @override
  _SearchMenuState createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  List<Result> _menuResults = [];

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

  Future<Search> fetchSearchPageDatas(CookieRequest request) async {
    final response = await request.postJson(
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menu-data/",
        jsonEncode(<String, String>{
          'query': "",
          'budget': "",
          'warung': "",
        }));

    Search searchData = Search.fromJson(response);

    _menuResults = searchData.results;

    return searchData;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final username = request.getJsonData()['username'];
    final crossAxisCount = getCrossAxisCount(MediaQuery.of(context).size.width);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'All Menu',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What do you want to eat?',
                style: GoogleFonts.poppins(fontSize: 25),
              ),
              const SizedBox(height: 30),
              FutureBuilder(
                future: fetchSearchPageDatas(request),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.orange,
                    ));
                  } else {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            'Tidak ada data yang ditemukan',
                            style: GoogleFonts.poppins(
                                fontSize: 20, color: const Color(0xff59A5D8)),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable internal scrolling
                        shrinkWrap: true, // Let the grid fit within its parent
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio: username != null
                              ? screenWidth * 0.0013
                              : screenWidth * 0.00159,
                        ),
                        itemCount: _menuResults.length,
                        itemBuilder: (context, index) {
                          Result menu = _menuResults[index];
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
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
