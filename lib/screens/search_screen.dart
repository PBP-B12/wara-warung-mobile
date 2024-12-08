import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wara_warung_mobile/models/search.dart';
import 'package:wara_warung_mobile/screens/edit_menu_screen.dart';
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
    final response = await request.get(
        'http://127.0.0.1:8000/search-menu?json=true&query=$_query&budget=$_selectedBudget');

    Search searchData = Search.fromJson(response);

    _menuResults = searchData.results;

    return searchData;
  }

  void deleteMenu(int id, CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/menu/delete/$id?json=true');
    if (response['status'] == 200) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Berhasil menghapus menu")),
        );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Gagal menghapus menu")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final username = request.getJsonData()['username'];
    final crossAxisCount = getCrossAxisCount(MediaQuery.of(context).size.width);

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
                          childAspectRatio: username != null ? 0.575 : 0.7,
                        ),
                        itemCount: _menuResults.length,
                        itemBuilder: (context, index) {
                          Result menu = _menuResults[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter, // Start at the top
                                end:
                                    Alignment.bottomCenter, // End at the bottom
                                colors: [
                                  Color(0xFFF5E6C5), // #f5e6c5
                                  Color(0xFFFFC5A5), // #ffc5a5
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  25), // Ensure clipping matches the container's borderRadius
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          filterQuality: FilterQuality.low,
                                          menu.gambar,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.error_outline_sharp),
                                                Text(
                                                  'Fail to Load this Image',
                                                  style: GoogleFonts.poppins(),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        if (username == "admin")
                                          Positioned(
                                            top: 4,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditMenuScreen(
                                                                  warung: menu
                                                                      .warung,
                                                                  menu:
                                                                      menu.menu,
                                                                  price: menu
                                                                      .harga,
                                                                  imageUrl: menu
                                                                      .gambar,
                                                                  id: menu.id,
                                                                )));
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7.5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.blue),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 17.5,
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  onTap: () => deleteMenu(
                                                      menu.id, request),
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7.5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.red),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 17.5,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                menu.menu,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.5,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Rp ${menu.harga}',
                                                style: GoogleFonts.poppins(),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.orange,
                                                    size: 15,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      menu.warung,
                                                      maxLines: 1,
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Rate : ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ), // Orange color for 'Rate :'
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${menu.avgRating} out of 5',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                      ), // Default color for the rest of the text
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                final id = menu.id;
                                                // TODO: goto Detail Page
                                                print('TODO: goto Detail Page');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 10),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  'See Details',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 12.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (username != null)
                                              Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      final id = menu.id;
                                                      // TODO: goto Add to List Page
                                                      print(
                                                          '// TODO: goto Add to List Page');
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6,
                                                          horizontal: 10),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Text(
                                                        'Add to List',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 12.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
