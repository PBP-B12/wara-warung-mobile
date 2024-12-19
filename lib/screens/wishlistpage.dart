import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/models/wishlist.dart';
import 'package:wara_warung_mobile/screens/homepage.dart';
import 'package:wara_warung_mobile/widgets/addcategory.dart';
import 'package:wara_warung_mobile/widgets/filtercard.dart';
import 'package:wara_warung_mobile/widgets/menucard3.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPage();
}

class _WishlistPage extends State<WishlistPage> {
  Future<List<Wishlist>> fetchWishlist(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/wishlist/json');

    List<Wishlist> listItem = [];
    for (var d in response) {
      if (d != null) {
        listItem.add(Wishlist.fromJson(d));
      }
    }
    return listItem;
  }

  Future<void> addCategory(CookieRequest request, String newCategory) async {
    await request.post(
      'http://127.0.0.1:8000/wishlist/add-category/', // API endpoint
      jsonEncode({'category_name': newCategory}),
    );
    setState(() {}); // Refresh UI
  }

 @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String selectedCategory = 'All Categories'; // Default category
    List<String> categories = ['All Categories', 'Breakfast', 'Lunch', 'Dinner'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Entry List'),
      ),
      body: FutureBuilder(
        future: fetchWishlist(request),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Card
                        SizedBox(
                          width: 200, // Ukuran tetap
                          height: 150,
                          child: FilterCard(
                            categories: categories,
                            selectedCategory: selectedCategory,
                            onCategoryChanged: (newCategory) {
                              selectedCategory = newCategory;
                            },
                            onFilter: () {
                              setState(() {});
                            },
                            backgroundColor: Colors.orange, // Warna seragam
                          ),
                        ),
                        const SizedBox(width: 16.0), // Jarak antar card

                        // Add Category Card
                        SizedBox(
                          width: 200, // Ukuran tetap
                          height: 150,
                          child: AddCategoryCard(
                            onAddCategory: (newCategory) =>
                                addCategory(request, newCategory),
                            backgroundColor: Colors.orange, // Warna seragam
                          ),
                        ),
                      ],
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dua kartu per baris
                      crossAxisSpacing: 8.0, // Spasi horizontal antar kartu
                      mainAxisSpacing: 8.0, // Spasi vertikal antar kartu
                      childAspectRatio: 0.75, // Rasio aspek kartu (lebar:tinggi)
                    ),
                    itemCount: wishlistData.length,
                    itemBuilder: (_, index) {
                      final wishlist = wishlistData[index];
                      return MenuCard(
                        title: wishlist.menu.name,
                        price: wishlist.menu.harga,
                        imageUrl: wishlist.menu.gambar,
                        assignedCategory: wishlist.categories.isNotEmpty
                            ? wishlist.categories[0].name
                            : '',
                        onAssignCategory: (newCategory) async {
                          await updateCategory(request, wishlist.menu.id, newCategory);
                          setState(() {});
                        },
                        onRemove: () async {
                          await removeWishlistItem(request, wishlist.menu.id);
                          setState(() {
                            wishlistData.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${wishlist.menu.name} has been removed from the wishlist'),
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
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }




}

Future<void> updateCategory(
    CookieRequest request, int menuId, String newCategory) async {
  await request.post(
    'http://127.0.0.1:8000/wishlist/update-category/', // Pastikan trailing slash
    jsonEncode({
      'menu_id': menuId,
      'category_name': newCategory,
    }),
  );
}

Future<void> removeWishlistItem(dynamic request, int menuId) async {
  try {
    // Contoh penghapusan item melalui API
    final response = await request.delete('/wishlist/$menuId');
    if (response.statusCode == 200) {
      print('Item successfully removed');
    } else {
      print('Failed to remove item');
    }
  } catch (e) {
    print('Error: $e');
  }
}
