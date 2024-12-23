import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/models/wishlist.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/widgets/menucard3.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';

class WishlistPage extends StatefulWidget {
  final int menu_id;
  WishlistPage({super.key, required this.menu_id});

  @override
  State<WishlistPage> createState() => _WishlistPage();
}

class _WishlistPage extends State<WishlistPage> {
  late CookieRequest _request;
  late TextEditingController _categoryController;
  String? _selectedCategories;
  bool _isLoadingCategories = true;
  List<String> _categoriesList = [];
  List<Wishlist> _filteredWishlist =
      []; // Menyimpan data wishlist yang difilter
  bool _isFiltering = false; // Menunjukkan apakah sedang dalam mode filter
  late Future<List<Wishlist>> _wishlistFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _request = context.read<CookieRequest>();

      // Fetch categories and wishlist data
      try {
        final categories = await fetchCategoryNames(_request);
        setState(() {
          _categoriesList = categories;
          _isLoadingCategories = false;
        });

        if (widget.menu_id != -1 && widget.menu_id != null) {
          await addMenuToWishlist(_request);
        }

        _wishlistFuture = fetchWishlist(_request);
      } catch (e) {
        debugPrint('Error during initialization: $e');
      } finally {
        // Set loading to false once everything is done
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> addMenuToWishlist(CookieRequest request) async {
    try {
      // Menambahkan menu baru ke wishlist
      final response = await request.post(
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/add_to_wishlist_flutter/',
        jsonEncode({'menu_id': widget.menu_id}),
      );

      if (response['status'] == 'success') {
        // Jika berhasil menambahkan menu, fetch ulang data wishlist
        final updatedWishlist = await fetchWishlist(request);
        setState(() {
          _isFiltering = false; // Pastikan mode filter dinonaktifkan
          _filteredWishlist.clear(); // Kosongkan data filter
          _filteredWishlist = updatedWishlist; // Perbarui data wishlist
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Menu berhasil ditambahkan ke wishlist')),
        );
      } else {
        throw Exception('Gagal menambahkan menu ke wishlist');
      }
    } catch (error) {
      debugPrint('Error adding menu to wishlist: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, coba lagi')),
      );
    }
  }

  Future<List<Wishlist>> fetchWishlist(CookieRequest request) async {
    final response = await request
        .get('https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/json');

    List<Wishlist> listItem = [];
    for (var d in response) {
      if (d != null) {
        listItem.add(Wishlist.fromJson(d));
      }
    }
    return listItem;
  }

  Future<void> fetchWishlistbyCategory(
      CookieRequest request, String categoryName) async {
    try {
      final response = await request.postJson(
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/show_wishlist_by_category/',
        jsonEncode({'category_name': categoryName}),
      );

      List<Wishlist> listItem = [];
      for (var d in response) {
        if (d != null) {
          listItem.add(Wishlist.fromJson(d));
        }
      }

      setState(() {
        _filteredWishlist = listItem; // Perbarui data wishlist yang difilter
        _isFiltering = true; // Setel mode filter
      });
    } catch (error) {
      debugPrint('Error fetching wishlist by category: $error');
      setState(() {
        _isFiltering = false; // Setel ulang jika terjadi error
      });
    }
  }

  Future<void> removeWishlistItem(CookieRequest request, int menuId) async {
    // Contoh penghapusan item melalui API
    // final response = await request.delete('/wishlist/$menuId');
    final response = await request.postJson(
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/remove-wishlist/",
        jsonEncode(<String, String>{'menu_id': menuId.toString()}));
  }

  Future<List<String>> fetchCategoryNames(CookieRequest request) async {
    try {
      final response = await request.get(
          'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/allcategory/');

      if (response is Map<String, dynamic> &&
          response.containsKey('categories')) {
        final categories = response['categories'];
        if (categories is List) {
          List<String> categoryNames = categories.map((item) {
            if (item is Map<String, dynamic> && item.containsKey('name')) {
              return item['name'].toString();
            } else {
              throw Exception('Unexpected item structure');
            }
          }).toList();

          // Tambahkan "All Categories" di awal daftar
          categoryNames.insert(0, 'All Categories');
          return categoryNames;
        } else {
          throw Exception('Unexpected categories structure');
        }
      } else {
        throw Exception('Unexpected response structure');
      }
    } catch (error) {
      debugPrint('Error fetching category names: $error');
      return [];
    }
  }

  Future<void> addCategory(CookieRequest request, String newCategory) async {
    try {
      if (newCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category name cannot be empty')),
        );
        return;
      }

      final response = await request.post(
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/add-category-flutter/', // API endpoint
        jsonEncode({'category_name': newCategory}),
      );

      if (response['status'] == 'success') {
        // Jika kategori berhasil ditambahkan, fetch ulang data kategori
        fetchCategoryNames(request).then((categories) {
          setState(() {
            _categoriesList = categories; // Perbarui daftar kategori
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added successfully')),
        );
        _categoryController.clear(); // Clear input field
      } else {
        throw Exception('Failed to add category');
      }
    } catch (error) {
      debugPrint('Error adding category: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error adding category, please try again')),
      );
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> updateCategory(
      CookieRequest request, int menuId, String newCategory) async {
    await request.post(
      'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/wishlist/assign_category_to_item_flutter/', // Pastikan trailing slash
      jsonEncode({
        'category_name': newCategory,
        'menu_id': menuId,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: Navbar(),
            body: FutureBuilder(
              future: _wishlistFuture,
              builder: (context, AsyncSnapshot<List<Wishlist>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data wishlist.',
                      style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                    ),
                  );
                } else {
                  final wishlistData = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            'Saved Wishlist',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: SingleChildScrollView(
                              // Tambahkan ini untuk menghindari overflow
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Add Category Card
                                  SizedBox(
                                    width: double
                                        .infinity, // Menyesuaikan lebar dengan layar
                                    child: Card(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Add New Category:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextField(
                                              controller: _categoryController,
                                              cursorColor: Colors
                                                  .black, // Ubah warna kursor menjadi hitam
                                              decoration: const InputDecoration(
                                                hintText: 'Category Name',
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    16), // Beri jarak antar elemen
                                            ElevatedButton(
                                              onPressed: () {
                                                addCategory(request,
                                                    _categoryController.text);
                                              },
                                              child: const Text('Add Category'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 16.0), // Jarak antar card
                                  // Filter Card
                                  SizedBox(
                                    width: double
                                        .infinity, // Menyesuaikan lebar dengan layar
                                    child: Card(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Choose Category:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton<String>(
                                              value: _selectedCategories,
                                              hint:
                                                  const Text('All Categories'),
                                              isExpanded: true,
                                              items: _isLoadingCategories
                                                  ? [
                                                      DropdownMenuItem(
                                                        value: null,
                                                        child: Row(
                                                          children: const [
                                                            SizedBox(
                                                              width: 16,
                                                              height: 16,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Loading...'),
                                                          ],
                                                        ),
                                                      ),
                                                    ]
                                                  : (_categoriesList.isNotEmpty
                                                      ? _categoriesList
                                                          .map((categoryName) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: categoryName,
                                                            child: Text(
                                                                categoryName),
                                                          );
                                                        }).toList()
                                                      : [
                                                          const DropdownMenuItem(
                                                            value: null,
                                                            child: Text(
                                                                'No Categories Available'),
                                                          ),
                                                        ]),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedCategories =
                                                      newValue;
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                                height:
                                                    16), // Beri jarak antar elemen
                                            ElevatedButton(
                                              onPressed: () {
                                                if (_selectedCategories !=
                                                        null &&
                                                    _selectedCategories !=
                                                        'All Categories') {
                                                  fetchWishlistbyCategory(
                                                      request,
                                                      _selectedCategories!);
                                                } else {
                                                  setState(() {
                                                    _isFiltering =
                                                        false; // Reset filter
                                                    _filteredWishlist.clear();
                                                  });
                                                }
                                              },
                                              child: const Text('Filter'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Title for Wishlist Items
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Wishlist Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Grid for Menu Cards
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Dua kartu per baris
                            crossAxisSpacing:
                                8.0, // Spasi horizontal antar kartu
                            mainAxisSpacing: 8.0, // Spasi vertikal antar kartu
                            childAspectRatio: screenWidth * 0.00120,
                          ),
                          itemCount: _isFiltering
                              ? _filteredWishlist.length
                              : wishlistData.length,
                          itemBuilder: (_, index) {
                            final wishlist = _isFiltering
                                ? _filteredWishlist[index]
                                : wishlistData[index];
                            return MenuCard(
                              title: wishlist.menu.name,
                              warung: wishlist.menu.warung,
                              price: wishlist.menu.harga,
                              imageUrl: wishlist.menu.gambar,
                              idMenu: wishlist.menu.id,
                              avgRating: 0.0,
                              request: request,
                              item: _isLoadingCategories
                                  ? [
                                      DropdownMenuItem(
                                        value: null,
                                        child: Row(
                                          children: const [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            ),
                                            SizedBox(width: 8),
                                            Text('Loading...'),
                                          ],
                                        ),
                                      ),
                                    ]
                                  : (_categoriesList.isNotEmpty
                                      ? _categoriesList.map((categoryName) {
                                          return DropdownMenuItem<String>(
                                            value:
                                                categoryName, // Nilai kategori
                                            child: Text(
                                                categoryName), // Tampilkan nama kategori
                                          );
                                        }).toList()
                                      : [
                                          const DropdownMenuItem(
                                            value: null,
                                            child:
                                                Text('No Categories Available'),
                                          ),
                                        ]),
                              assignedCategory: wishlist.categories.isNotEmpty
                                  ? wishlist.categories[0].name
                                  : '',
                              onAssignCategory: (newCategory) async {
                                await updateCategory(
                                    request, wishlist.menu.id, newCategory);

                                // Fetch the updated wishlist and refresh the screen
                                setState(() {
                                  _wishlistFuture = fetchWishlist(request);
                                });

                                // Fetch ulang data menu berdasarkan kategori yang dipilih
                                if (_selectedCategories != null &&
                                    _selectedCategories!.isNotEmpty) {
                                  await fetchWishlistbyCategory(
                                      request, _selectedCategories!);
                                } else {
                                  // Jika kategori tidak dipilih, reset ke semua menu
                                  setState(() {
                                    _isFiltering = false;
                                    _filteredWishlist.clear();
                                  });
                                }
                                setState(() {}); // Perbarui tampilan
                              },
                              onRemove: () async {
                                await removeWishlistItem(
                                    request, wishlist.menu.id);
                                setState(() {
                                  if (_isFiltering) {
                                    _filteredWishlist.removeAt(index);
                                  } else {
                                    wishlistData.removeAt(index);
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${wishlist.menu.name} has been removed from the wishlist'),
                                  ),
                                );
                              },
                              onSeeDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
  }
}
