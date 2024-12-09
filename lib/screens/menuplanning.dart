import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/models/search.dart';
import 'package:wara_warung_mobile/screens/savedmenu.dart';

class MenuPlanningPage extends StatefulWidget {
  const MenuPlanningPage({Key? key}) : super(key: key);

  @override
  State<MenuPlanningPage> createState() => _MenuPlanningPageState();
}

class _MenuPlanningPageState extends State<MenuPlanningPage> {
  final Map<String, int> _cartItems = {}; // Cart items and their quantities
  String? _selectedWarung; // Selected Warung
  final TextEditingController _budgetController =
      TextEditingController(text: '100000'); // Budget input
  int _totalCartValue = 0;

  Future<List<Result>> fetchMenus(CookieRequest request) async {
    String warungFilter = _selectedWarung == null ? "" : _selectedWarung!;
    int? budgetFilter = int.tryParse(_budgetController.text) == null
        ? 100000
        : int.tryParse(_budgetController.text)!;
    // API endpoint to fetch all menus
    final response = await request.get(
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/search-menu?json=true&warung=$warungFilter&budget=$budgetFilter');

    List<Result> listMenu = [];
    listMenu = Search.fromJson(response).results;
    return listMenu; // Return the full menu list
  }

  void _addToCart(String itemName, int price) {
    setState(() {
      final int newTotal = _totalCartValue + price;

      if (newTotal > int.tryParse(_budgetController.text)!) {
        // Exceed budget - reset cart
        _showErrorDialog('Total exceeds your budget. Cart will be reset.');
        _cartItems.clear();
        _totalCartValue = 0;
      } else {
        _cartItems[itemName] = (_cartItems[itemName] ?? 0) + 1;
        _totalCartValue = newTotal;
      }
    });
  }

  void _removeFromCart(String itemName, int price) {
    setState(() {
      if (_cartItems.containsKey(itemName) && _cartItems[itemName]! > 0) {
        _totalCartValue -= price;
        _cartItems[itemName] = _cartItems[itemName]! - 1;
        if (_cartItems[itemName] == 0) {
          _cartItems.remove(itemName);
        }
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const SavedMenuPage();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7428),
                ),
                child: const Text('Saved Menu'),
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
    final CookieRequest request = CookieRequest();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        title: const Text('Menu Planning'),
        backgroundColor: const Color(0xFFFF7428),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown and Budget Input Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6E1F),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedWarung,
                        hint: const Text(
                          'Select Warung',
                          style: TextStyle(color: Colors.white),
                        ),
                        items:
                            ['Warung Lestari', 'Warung Man Luh', 'Warung Sari']
                                .map((warung) => DropdownMenuItem<String>(
                                      value: warung,
                                      child: Text(warung),
                                    ))
                                .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedWarung = newValue;
                          });
                        },
                        dropdownColor: const Color(0xFFFF6E1F),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6E1F),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Budget',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Menu Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Display Menu Items Dynamically Using FutureBuilder
            Expanded(
              child: FutureBuilder<List<Result>>(
                future: fetchMenus(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No menu items available.'));
                  } else {
                    final menus = snapshot.data!;
                    return ListView.separated(
                      itemCount: menus.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8), // Space between boxes
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return _buildMenuItem(
                          screenWidth,
                          menu.menu,
                          menu.harga,
                          menu.gambar,
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
        onPressed: _showCartItems, // Implement this method to show cart items
        backgroundColor: const Color(0xFFFF7428),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildMenuItem(
      double screenWidth, String itemName, int price, String imageUrl) {
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
                    'Rp ${price.toString()}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeFromCart(itemName, price),
                ),
                Text(
                  '${_cartItems[itemName] ?? 0}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => _addToCart(itemName, price),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
