import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wara_warung_mobile/models/chosenmenu.dart';

class SavedMenuPage extends StatefulWidget {
  const SavedMenuPage({super.key});

  @override
  State<SavedMenuPage> createState() => _SavedMenuPageState();
}

class _SavedMenuPageState extends State<SavedMenuPage> {
  late Future<List<ChosenMenu>> savedMenus;

  @override
  void initState() {
    super.initState();
    savedMenus = fetchSavedMenus();
  }

  Future<List<ChosenMenu>> fetchSavedMenus() async {
    final url = Uri.parse('http://127.0.0.1:8000/menuplanning/chosen-menus/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => ChosenMenu.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load saved menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Menus'),
      ),
      body: FutureBuilder<List<ChosenMenu>>(
        future: savedMenus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved menus found.'));
          } else {
            final groupedMenus = _groupBySaveSession(snapshot.data!);
            return ListView(
              children: groupedMenus.entries.map((entry) {
                final session = entry.key;
                final menus = entry.value;

                return SavedMenuCard(
                  session: session,
                  menus: menus,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  // Group ChosenMenu items by save_session
  Map<int, List<ChosenMenu>> _groupBySaveSession(List<ChosenMenu> menus) {
    final Map<int, List<ChosenMenu>> grouped = {};
    for (var menu in menus) {
      grouped.putIfAbsent(menu.saveSession, () => []).add(menu);
    }
    return grouped;
  }
}

class SavedMenuCard extends StatelessWidget {
  final int session;
  final List<ChosenMenu> menus;

  const SavedMenuCard({Key? key, required this.session, required this.menus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPrice = menus.fold(
      0.0,
      (sum, menu) => sum + (menu.quantity * menu.price),
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu Plan $session',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...menus.map((menu) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${menu.quantity} x ${menu.itemName} = Rp ${(menu.quantity * menu.price).toStringAsFixed(0)}',
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            Text(
              'Total: Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
