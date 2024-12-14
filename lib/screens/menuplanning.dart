import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'savedmenu.dart'; // Import the SavedMenuPage here

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
  void initState() {
    super.initState();
    fetchWarungNames().then((warungNames) {
      setState(() {
        _warungList = warungNames;
        _isLoadingWarung = false;
      });
    });
  }

  Future<List<String>> fetchWarungNames() async {
    const String apiUrl =
        'http://127.0.0.1:8000/menuplanning/api/warungs/'; // Update the URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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

  Future<List<Menu>> _fetchMenus() async {
    if (_selectedWarung == null || _selectedWarung!.isEmpty) {
      return []; // Return empty if no warung is selected
    }

    final String apiUrl =
        'http://127.0.0.1:8000/menuplanning/api/menus/$_selectedWarung/'; // Update the URL
    try {
      final response = await http.get(Uri.parse('$apiUrl'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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


Future<void> _saveCart() async {
  if (_cartItems.isEmpty) {
    _showErrorDialog('Your cart is empty. Add items before saving.');
    return;
  }

  setState(() {
    _isSaving = true; // Show loading indicator
  });

  const String apiUrl = 'http://127.0.0.1:8000/menuplanning/create-menu-flutter/';
  final String budget = _budgetController.text;
  final int saveSessionId = DateTime.now().millisecondsSinceEpoch; // Generate unique session ID

  // Construct JSON payload
  final List<Map<String, dynamic>> cartItemsJson = _cartItems.entries.map((entry) {
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
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cartItemsJson), // Send as a JSON list
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        _showSuccessDialog('Cart saved successfully!');
        setState(() {
          _cartItems.clear();
          _totalCartValue = 0;
        });
      } else {
        _showErrorDialog(result['message'] ?? 'Failed to save cart.');
      }
    } else {
      final error = jsonDecode(response.body);
      _showErrorDialog(error['message'] ?? 'An error occurred.');
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

void _showCartItems() {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => _removeFromCart(itemName, itemPrice),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () => _addToCart(itemName, itemPrice),
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
              onPressed: _isSaving ? null : _saveCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSaving ? Colors.grey : const Color(0xFFFF7428),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Menu',
                      style: TextStyle(
                        color: Colors.black, // Set the text color to black
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        title: const Text('Menu Planning'),
        backgroundColor: const Color(0xFFFF7428),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedMenuPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    value: _selectedWarung,
                    hint: const Text('Select Warung'),
                    items: _isLoadingWarung
                        ? [
                            DropdownMenuItem(
                              value: null,
                              child: Row(
                                children: const [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
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
                Expanded(
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
                future: _fetchMenus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Select Warung and Preferred Budget.'));
                  } else {
                    final menus = snapshot.data!;
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Column(
                          children: [
                            _buildMenuItem(
                              MediaQuery.of(context).size.width, // Pass screen width
                              menu.itemName,
                              menu.price,
                              menu.imageUrl,
                            ),
                            const SizedBox(height: 16), // Add spacing between boxes
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
        onPressed: _showCartItems,
        backgroundColor: const Color(0xFFFF7428),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

Widget _buildMenuItem(
    double screenWidth, String itemName, int price, String imageUrl) {
  final int quantity = _cartItems[itemName]?['quantity'] ?? 0; // Get current quantity

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
          Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
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
                  'Rp $price',
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
