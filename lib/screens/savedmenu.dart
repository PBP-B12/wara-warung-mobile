import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:wara_warung_mobile/models/chosenmenu.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';
import 'package:intl/intl.dart';

class SavedMenuPage extends StatefulWidget {
  const SavedMenuPage({super.key});

  @override
  State<SavedMenuPage> createState() => _SavedMenuPageState();
}

class _SavedMenuPageState extends State<SavedMenuPage> {
  late Future<List<ChosenMenu>> savedMenus;

  String? _filterWarungName;
  int? _filterBudget;

  List<String> _warungList = [];
  bool _isLoadingWarung = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final request = context.read<CookieRequest>();
    _loadWarungNames(request);
    savedMenus = fetchSavedMenus(request);
  }

  @override
  void initState() {
    super.initState();
  }

  void _loadWarungNames(CookieRequest request) async {
    setState(() {
      _isLoadingWarung = true;
    });

    List<String> warungNames = await fetchWarungNames(request);
    setState(() {
      _warungList = warungNames;
      _isLoadingWarung = false;
    });
  }

  Future<List<String>> fetchWarungNames(CookieRequest request) async {
    const String apiUrl =
        'https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menuplanning/api/warungs/flutter/';
    try {
      final response = await request.get(apiUrl);

      if (response["status"] == 200) {
        final Map<String, dynamic> data = response["body"];
        if (data.containsKey('warungs') && data['warungs'] is List) {
          return (data['warungs'] as List<dynamic>)
              .map((item) => item["nama"].toString())
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

  void _openFilterDialog(CookieRequest request) {
    String? localWarungName = _filterWarungName;
    TextEditingController budgetController = TextEditingController(
      text: _filterBudget != null ? _filterBudget.toString() : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Saved Menus'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    value: localWarungName,
                    hint: const Text('Select Warung'),
                    items: _isLoadingWarung
                        ? [
                            const DropdownMenuItem(
                              value: null,
                              child: Row(
                                children: [
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
                      setDialogState(() {
                        localWarungName = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _filterBudget = int.tryParse(value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterWarungName = localWarungName;
                      _filterBudget = int.tryParse(budgetController.text);
                      savedMenus = fetchSavedMenus(request);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeFilters(CookieRequest request) {
    setState(() {
      _filterWarungName = null;
      _filterBudget = null;
      savedMenus = fetchSavedMenus(request);
    });
  }

  Future<List<ChosenMenu>> fetchSavedMenus(CookieRequest request) async {
    final response = await request.get(
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/menuplanning/chosen-menus/json/");

    if (response["status"] == 200) {
      List<dynamic> jsonResponse = response["body"];
      List<ChosenMenu> menus =
          jsonResponse.map((data) => ChosenMenu.fromJson(data)).toList();

      if (_filterWarungName != null && _filterWarungName!.isNotEmpty) {
        menus = menus
            .where((menu) => menu.warungName == _filterWarungName)
            .toList();
      }
      if (_filterBudget != null) {
        menus = menus.where((menu) => menu.budget <= _filterBudget!).toList();
      }

      return menus;
    } else {
      throw Exception('Failed to load saved menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      appBar: Navbar(),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              'Saved Menu Plans',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _openFilterDialog(request);
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text(
                    'Filter',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _removeFilters(request);
                  },
                  icon: const Icon(Icons.clear, color: Colors.white),
                  label: const Text(
                    'Remove Filters',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<ChosenMenu>>(
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
                  return ListView.builder(
                    itemCount: groupedMenus.length,
                    itemBuilder: (context, index) {
                      final session = groupedMenus.keys.elementAt(index);
                      final menus = groupedMenus[session]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SavedMenuCard(
                          session: session,
                          menus: menus,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFBF2),
    );
  }

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

  const SavedMenuCard({
    Key? key,
    required this.session,
    required this.menus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPrice = menus.fold(
      0.0,
      (sum, menu) => sum + (menu.quantity * menu.price),
    );

    final warungName = menus.isNotEmpty ? menus.first.warungName : 'Unknown';
    final budget = menus.isNotEmpty
        ? 'Budget: Rp ${NumberFormat('#,###', 'id_ID').format(menus.first.budget)}'
        : '';

    return Card(
      margin: const EdgeInsets.all(6.0),
      elevation: 2.0,
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
            Text(
              warungName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              budget,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: menus.map((menu) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${menu.quantity} x ${menu.itemName} = Rp ${NumberFormat('#,###', 'id_ID').format((menu.quantity * menu.price))}',
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: Rp ${NumberFormat('#,###', 'id_ID').format(totalPrice)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
