import 'package:flutter/material.dart';

class SavedMenuPage extends StatelessWidget {
  const SavedMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for UI
    final List<MenuPlan> dummyMenuPlans = [
      MenuPlan(
        name: 'Menu Plan 1',
        budget: 100000,
        totalPrice: 85000,
        items: [
          MenuItem(itemName: 'Nasi Goreng', quantity: 2, total: 40000),
          MenuItem(itemName: 'Mie Goreng', quantity: 1, total: 15000),
          MenuItem(itemName: 'Soto Ayam', quantity: 1, total: 30000),
        ],
      ),
      MenuPlan(
        name: 'Menu Plan 2',
        budget: 150000,
        totalPrice: 120000,
        items: [
          MenuItem(itemName: 'Ayam Penyet', quantity: 2, total: 50000),
          MenuItem(itemName: 'Gado-Gado', quantity: 1, total: 20000),
          MenuItem(itemName: 'Bakso', quantity: 2, total: 50000),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        title: const Text('My Saved Menus'),
        backgroundColor: const Color(0xFFFF7428),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF252525),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text('Add New Menu Plan'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dummyMenuPlans.length,
                itemBuilder: (context, index) {
                  final menuPlan = dummyMenuPlans[index];
                  return SavedMenuCard(menuPlan: menuPlan);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add reset functionality later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Reset functionality not implemented yet.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3342F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text('Reset All Saved Menus'),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedMenuCard extends StatelessWidget {
  final MenuPlan menuPlan;

  const SavedMenuCard({Key? key, required this.menuPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuPlan.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget: Rp${menuPlan.budget.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text('Menu:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...menuPlan.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${item.quantity} x ${item.itemName} = Rp${item.total.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            Text(
              'Total = Rp${menuPlan.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPlan {
  final String name;
  final double budget;
  final List<MenuItem> items;
  final double totalPrice;

  MenuPlan({
    required this.name,
    required this.budget,
    required this.items,
    required this.totalPrice,
  });
}

class MenuItem {
  final String itemName;
  final int quantity;
  final double total;

  MenuItem({
    required this.itemName,
    required this.quantity,
    required this.total,
  });
}
