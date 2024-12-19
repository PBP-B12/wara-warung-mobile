import 'package:flutter/material.dart';
class FilterCard extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;
  final VoidCallback onFilter;
  final Color backgroundColor;

  const FilterCard({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onFilter,
    this.backgroundColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Category:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onCategoryChanged(value);
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onFilter,
              child: const Text('Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
