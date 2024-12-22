import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/widgets/navbarmenuplan.dart';
import 'savedmenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MenuPlanningPage extends StatefulWidget {
  const MenuPlanningPage({Key? key}) : super(key: key);

  @override
  State<MenuPlanningPage> createState() => _MenuPlanningPageState();
}

class _MenuPlanningPageState extends State<MenuPlanningPage> {
  final Map<String, Map<String, dynamic>> _cartItems = {};
  String? _selectedWarung;
  final TextEditingController _budgetController =
      TextEditingController(text: '100000');
  int _totalCartValue = 0;

  List<String> _warungList = [];
  bool _isLoadingWarung = true;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final request = context.read<CookieRequest>();
    fetchWarungNames(request).then((warungNames) {
      setState(() {
        _warungList = warungNames;
        _isLoadingWarung = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> fetchWarungNames(CookieRequest request) async {
    const String apiUrl =
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menuplanning/api/warungs/flutter/'; // Update the URL
    try {
      final response = await request.get(apiUrl);
      if (response["status"] == 200) {
        final Map<String, dynamic> data = response["body"];
        if (data.containsKey('warungs') && data['warungs'] is List) {
          return (data['warungs'] as List<dynamic>)
              .map((item) => item['nama'].toString())
              .toList();
        } else {
          throw Exception('Unexpected data structure');
        }
      } else {
        throw Exception('Failed to load warung names');
      }
    } catch (error) {
      debugPrint('Error fetching warung names: $error');
      return [];
    }
  }

  Future<List<Menu>> _fetchMenus(CookieRequest request) async {
    if (_selectedWarung == null || _selectedWarung!.isEmpty) {
      return []; // Return empty if no warung is selected
    }

    final String apiUrl =
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menuplanning/api/menus/flutter/$_selectedWarung/'; // Update the URL
    try {
      final response = await request.get(apiUrl);
      if (response["status"] == 200) {
        final Map<String, dynamic> data = response["body"];
        if (data.containsKey('menus') && data['menus'] is List) {
          return (data['menus'] as List<dynamic>)
              .map((item) => Menu.fromJson(item))
              .toList();
        } else {
          throw Exception('Unexpected data structure');
        }
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (error) {
      debugPrint('Error fetching menus: $error');
      return [];
    }
  }

  void _addToCart(String itemName, int price) {
    setState(() {
      if (!_cartItems.containsKey(itemName)) {
        _cartItems[itemName] = {'quantity': 0, 'price': price};
      }
      final int currentQuantity = _cartItems[itemName]!['quantity'] as int;
      final int newTotal = _totalCartValue + price;

      if (newTotal > int.tryParse(_budgetController.text)!) {
        _showErrorDialog('Total exceeds your budget. Cart will be reset.');
        _cartItems.clear();
        _totalCartValue = 0;
      } else {
        _cartItems[itemName]!['quantity'] = currentQuantity + 1;
        _totalCartValue = newTotal;
      }
    });
  }

  void _removeFromCart(String itemName, int price) {
    setState(() {
      if (_cartItems.containsKey(itemName) &&
          (_cartItems[itemName]!['quantity'] as int) > 0) {
        final int currentQuantity = _cartItems[itemName]!['quantity'] as int;
        final int newTotal = _totalCartValue - price;

        _cartItems[itemName]!['quantity'] = currentQuantity - 1;
        _totalCartValue = newTotal;

        if (_cartItems[itemName]!['quantity'] == 0) {
          _cartItems.remove(itemName);
        }
      }
    });
  }

  Future<void> _saveCart(CookieRequest request) async {
    if (_cartItems.isEmpty) {
      _showErrorDialog('Your cart is empty. Add items before saving.');
      return;
    }

    setState(() {
      _isSaving = true; // Show loading indicator
    });

    const String apiUrl =
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menuplanning/create-menu-flutter/';
    final String budget = _budgetController.text;
    final int saveSessionId =
        DateTime.now().millisecondsSinceEpoch; // Generate unique session ID

    // Construct JSON payload
    final List<Map<String, dynamic>> cartItemsJson =
        _cartItems.entries.map((entry) {
      return {
        "model": "menuplanning.chosenmenu",
        "fields": {
          "user": 1, // Replace with actual user ID if available
          "item_name": entry.key,
          "quantity": entry.value['quantity'],
          "price": entry.value['price'].toStringAsFixed(2),
          "save_session": saveSessionId,
          "budget": budget,
        }
      };
    }).toList();

    try {
      final response =
          await request.postJson(apiUrl, jsonEncode(cartItemsJson));

      if (response["status"] == "success") {
        _showSuccessDialog('Cart saved successfully!');

        setState(() {
          _cartItems.clear(); // Clear cart
          _totalCartValue = 0; // Reset total cart value
          _selectedWarung = null; // Reset warung selection
          _budgetController.text = '100000'; // Reset budget
        });
      } else {
        _showErrorDialog(response['message'] ?? 'Failed to save cart.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    } finally {
      setState(() {
        _isSaving = false; // Hide loading indicator
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCartItems(CookieRequest request) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_cartItems.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: _cartItems.entries.map(
                          (entry) {
                            final itemName = entry.key;
                            final quantity = entry.value['quantity'];
                            final itemPrice = entry.value['price'];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _removeFromCart(
                                                itemName, itemPrice);
                                          });
                                          setModalState(
                                              () {}); // Perbarui UI di modal
                                        },
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle,
                                            color: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            _addToCart(itemName, itemPrice);
                                          });
                                          setModalState(
                                              () {}); // Perbarui UI di modal
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    )
                  else
                    const Text(
                      'Your cart is empty.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: Rp$_totalCartValue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _isSaving ? null : _saveCart(request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSaving ? Colors.grey : const Color(0xFFFF7428),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Menu',
                            style: TextStyle(
                              color:
                                  Colors.black, // Set the text color to black
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final request = context.read<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: NavbarMenuPlan(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Menu Planning',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: DropdownButton<String>(
                    value: _selectedWarung,
                    hint: const Text('Select Warung'),
                    isExpanded:
                        true, // Menyesuaikan dropdown dengan lebar yang tersedia
                    items: _isLoadingWarung
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
                        : _warungList.map((warung) {
                            return DropdownMenuItem<String>(
                              value: warung,
                              child: Text(warung),
                            );
                          }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedWarung = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      hintText: 'Budget',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Menu>>(
                future: _fetchMenus(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Select Warung and Preferred Budget.'));
                  } else {
                    final menus = snapshot.data!;
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Column(
                          children: [
                            _buildMenuItem(
                              MediaQuery.of(context)
                                  .size
                                  .width, // Pass screen width
                              menu.itemName,
                              menu.price,
                              menu.imageUrl,
                            ),
                            const SizedBox(
                                height: 16), // Add spacing between boxes
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCartItems(request);
        },
        backgroundColor: const Color(0xFFFF7428),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildMenuItem(
      double screenWidth, String itemName, int price, String imageUrl) {
    final int quantity =
        _cartItems[itemName]?['quantity'] ?? 0; // Get current quantity

    return Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5E6C5), Color(0xFFFFC5A5)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 80, // Lebar tetap
              height: 80, // Tinggi tetap
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_sharp, size: 30),
                        Text(
                          'Fail Load\nImage',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(price)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    if (quantity > 0) {
                      _removeFromCart(itemName, price);
                    }
                  },
                ),
                Text(
                  '$quantity', // Show the quantity here
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    _addToCart(itemName, price);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Menu {
  final String itemName;
  final int price;
  final String imageUrl;

  Menu({
    required this.itemName,
    required this.price,
    required this.imageUrl,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      itemName: json['menu'],
      price: json['harga'],
      imageUrl: json['gambar'],
    );
  }
}
