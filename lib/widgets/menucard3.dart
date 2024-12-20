import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/screens/edit_menu_screen.dart';
import 'package:wara_warung_mobile/screens/ratereview_menu.dart';
import 'package:wara_warung_mobile/screens/search_screen.dart';

class MenuCard extends StatefulWidget {
  final String title;
  final String warung;
  final int price;
  final String imageUrl;
  final int idMenu;
  final double avgRating;
  final CookieRequest request;
  final List<DropdownMenuItem<String>> item;
  final String assignedCategory;
  final Future<void> Function(String newCategory) onAssignCategory;
  final VoidCallback onRemove; // Callback untuk tombol Remove
  final VoidCallback onSeeDetails; // Callback untuk tombol See Details

  const MenuCard({
    super.key,
    required this.title,
    required this.warung,
    required this.price,
    required this.imageUrl,
    required this.idMenu,
    required this.avgRating,
    required this.request,
    required this.item,
    required this.assignedCategory,
    required this.onAssignCategory,
    required this.onRemove,
    required this.onSeeDetails,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  String? selectedCategory;
  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.assignedCategory.isNotEmpty ? widget.assignedCategory : null;
  }

  void deleteMenu(int id, CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/menu/delete-json/$id');
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
    final username = widget.request.getJsonData()['username'];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, // Start at the top
          end: Alignment.bottomCenter, // End at the bottom
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
              flex: 3,
              child: Stack(
                children: [
                  Image.network(
                    filterQuality: FilterQuality.low,
                    widget.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_sharp),
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
                                      builder: (context) => EditMenuScreen(
                                            warung: widget.warung,
                                            menu: widget.title,
                                            price: widget.price,
                                            imageUrl: widget.imageUrl,
                                            id: widget.idMenu,
                                          )));
                            },
                            child: Container(
                                padding: const EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
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
                            onTap: () =>
                                deleteMenu(widget.idMenu, widget.request),
                            child: Container(
                                padding: const EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp ${widget.price}',
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          "Category : ${widget.assignedCategory.isNotEmpty ? widget.assignedCategory.padRight(15, ' ') : "None      "}",
                          maxLines: 1,
                          style: GoogleFonts.poppins(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewPage(
                                      warung: widget.warung,
                                      menu: widget.title,
                                      price: widget.price,
                                      id: widget.idMenu,
                                      imageUrl: widget.imageUrl,
                                      avgRatings: widget.avgRating,
                                    )),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
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
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: widget.onRemove,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Remove Menu',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Dropdown untuk Assign Category
                      DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        value: selectedCategory,
                        isDense: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        iconSize: 15,
                        items: widget.item,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        hint: Text(
                          'Select Category',
                          style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight
                                  .w500), // Font lebih kecil untuk placeholder
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight
                                .w500 // Font lebih kecil untuk item yang dipilih
                            ),
                      ),
                      const SizedBox(height: 10),

                      // Tombol Assign
                      InkWell(
                        onTap: () async {
                          if (selectedCategory != null) {
                            await widget.onAssignCategory(selectedCategory!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Assigned category updated to $selectedCategory',
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Assign',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
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
  }
}
