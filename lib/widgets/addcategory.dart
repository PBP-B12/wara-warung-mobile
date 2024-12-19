import 'package:flutter/material.dart';
class AddCategoryCard extends StatelessWidget {
  final Function(String) onAddCategory;
  final Color backgroundColor;

  const AddCategoryCard({
    required this.onAddCategory,
    this.backgroundColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Category:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(hintText: 'Category Name'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                onAddCategory(categoryController.text);
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
