import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wara_warung_mobile/models/search.dart';
import 'package:wara_warung_mobile/widgets/menucardv2.dart';
import '../widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
  Timer? _debounce;
  int? _selectedBudget = 1000000;
  String _query = "";
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
            "http://127.0.0.1:8000/menu-data/",
            jsonEncode(<String, String>{
                'query': _query,
                'budget': _selectedBudget.toString(),
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
                'Search Menu',
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search, color: Colors.red),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();

                          // Start a new timer
                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            // Callback function executed after debounce duration
                            if (value != _query) {
                              setState(() {
                                _query = value;
                                fetchSearchPageDatas(request);
                              });
                            }
                            // You can add your API call or state update here
                          });
                        },
                      ),
                    ),
                    const VerticalDivider(color: Colors.grey),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedBudget,
                          alignment: Alignment.center,
                          isDense: true,
                          isExpanded: true,
                          items: <int>[
                            1000000,
                            10000,
                            20000,
                            30000,
                          ].map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    value == 1000000
                                        ? "Budget"
                                        : "≤ ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match match) => '${match[1]},')}",
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  if (value == 'Budget')
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedBudget = newValue;
                              fetchSearchPageDatas(request);
                            });
                          },
                          icon: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
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
                          childAspectRatio: username != null ? screenWidth * 0.0013 : screenWidth * 0.00159,
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
