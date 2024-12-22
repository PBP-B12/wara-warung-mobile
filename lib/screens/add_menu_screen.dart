import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/add_edit_menu.dart';

class AddNewMenuScreen extends StatefulWidget {
  const AddNewMenuScreen({super.key});

  @override
  State<AddNewMenuScreen> createState() => _AddNewMenuScreenState();
}

class _AddNewMenuScreenState extends State<AddNewMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  String _warung = "";
  String _menu = "";
  int _price = 0;
  String _imageUrl = "";

  Future<AddEditMenu> fetchAddMenuScreenData(CookieRequest request) async {
    final response = await request.get(
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menu/get-warungs/');

    AddEditMenu editMenuData = AddEditMenu.fromJson(response);

    return editMenuData;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Menu',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFFFFBF2),
      body: FutureBuilder(
        future: fetchAddMenuScreenData(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Terjadi kesalahan mengambil data komponen untuk Warung',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              AddEditMenu dataEdit = snapshot.data;
              List<String> warungNameList = [];
              for (var i in dataEdit.dropdownWarungs) {
                warungNameList.add(i.nama);
              }

              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      // Dropdown for Warung
                      Text(
                        'Warung',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: warungNameList
                            .map((warung) => DropdownMenuItem(
                                  value: warung,
                                  child: Text(warung,
                                      style: GoogleFonts.poppins(fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _warung = value!;
                          });
                        },
                        hint: Text(
                          'Select a Warung',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Menu Name Input
                      Text(
                        'Menu Name',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter menu name',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _menu = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Name must be filled!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Price Input
                      Text(
                        'Price',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter price',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _price = int.tryParse(value!) ?? 0;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Price must be filled!";
                          }
                          if (int.tryParse(value) == null) {
                            return "Price must be Integer!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Image URL Input
                      Text(
                        'Image URL',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter image URL',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _imageUrl = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Image url must be filled!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Buttons: Cancel and Save
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Handle save action
                                if (_formKey.currentState!.validate()) {
                                  final response = await request.postJson(
                                    "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menu/add-menu-flutter/",
                                    jsonEncode(<String, dynamic>{
                                      'warung': _warung,
                                      'menu': _menu,
                                      'harga': _price,
                                      'gambar': _imageUrl,
                                    }),
                                  );
                                  if (context.mounted) {
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Menu added successfully!"),
                                      ));
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Terdapat kesalahan, silakan coba lagi."),
                                      ));
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
