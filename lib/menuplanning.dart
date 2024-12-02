import 'package:flutter/material.dart';

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

  // Add an item to the cart
  void _addToCart(String itemName, int price) {
    setState(() {
      final int newTotal = _totalCartValue + price;

      if (newTotal > int.tryParse(_budgetController.text)!) {
        // Exceed budget - reset cart
        _showErrorDialog('Total exceeds your budget. Cart will be reset.');
        _cartItems.clear();
        _totalCartValue = 0;
      } else {
        // Update cart normally
        _cartItems[itemName] = (_cartItems[itemName] ?? 0) + 1;
        _totalCartValue = newTotal;
      }
    });
  }

  // Remove an item from the cart
  void _removeFromCart(String itemName, int price) {
    setState(() {
      if (_cartItems.containsKey(itemName) && _cartItems[itemName]! > 0) {
        _totalCartValue -= price;
        _cartItems[itemName] = _cartItems[itemName]! - 1;
        if (_cartItems[itemName] == 0) {
          _cartItems.remove(itemName); // Remove from cart if quantity is zero
        }
      }
    });
  }

  // Show error dialog
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

  // Show the cart items in a popup modal
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
                ..._cartItems.entries.map(
                  (entry) => Padding(
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
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () =>
                                  _removeFromCart(entry.key, 20000), // Example price
                            ),
                            Text(
                              '${entry.value}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green),
                              onPressed: () =>
                                  _addToCart(entry.key, 20000), // Example price
                            ),
                          ],
                        ),
                      ],
                    ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dropdown and Budget Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Warung Dropdown
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
                        items: ['Warung Lestari', 'Warung Man Luh', 'Warung Sari']
                            .map((warung) => DropdownMenuItem<String>(
                                  value: warung,
                                  child: Text(warung),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWarung = value;
                          });
                        },
                        dropdownColor: const Color(0xFFFF6E1F),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Budget Input
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

            // Menu Items Section
            const Text(
              'Menu Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(screenWidth, 'Nasi Goreng', 20000),
            const SizedBox(height: 16),
            _buildMenuItem(screenWidth, 'Mie Goreng', 15000),
            const SizedBox(height: 16),
            _buildMenuItem(screenWidth, 'Soto Ayam', 25000),
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

  // Build a menu item with + and - buttons for quantity
  Widget _buildMenuItem(double screenWidth, String itemName, int price) {
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
      padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              ElevatedButton(
                onPressed: () => _addToCart(itemName, price),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7428),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
