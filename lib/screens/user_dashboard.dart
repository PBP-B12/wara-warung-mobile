import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';
import 'package:wara_warung_mobile/widgets/bottomnavbar.dart';
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  // User data fields
  String username = "";
  String email = "";
  String phoneNumber = "";
  String dateOfBirth = "";
  String address = "";

  // Controller for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final request = context.watch<CookieRequest>();
    _fetchUserData(request);
    super.didChangeDependencies();
  }

  // Fetch user data from Django
  void _fetchUserData(CookieRequest request) async {
    final response = await request
        .get("http://127.0.0.1:8000/user_dashboard/get-user-dashboard-data/");

    if (response != null) {
      setState(() {
        email = response['email'] ?? '';
        phoneNumber = response['phone_number'] ?? '';
        dateOfBirth = response['date_of_birth'] ?? '';
        address = response['address'] ?? '';
        username = response['username'] ?? '';
      });
    }
  }

  // Function to open the Edit Details Form
  void _openEditForm() {
    // Pre-fill controllers with existing data
    _emailController.text = email;
    _phoneController.text = phoneNumber;
    _dobController.text = dateOfBirth;
    _addressController.text = address;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildFormField('Email', _emailController),
                _buildFormField('Phone Number', _phoneController),
                _buildFormField('Date of Birth', _dobController, isDate: true),
                _buildFormField('Address', _addressController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => _saveChanges(context), // Pass the dialog's context
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Save user data to Django
  void _saveChanges(BuildContext dialogContext) async {
    final request = context.read<CookieRequest>();
    bool success = false;

    try {
      // Send the updated user data to Django
      final response = await request.postJson(
        "http://127.0.0.1:8000/user_dashboard/update-user/",
        jsonEncode({
          'email': _emailController.text,
          'phone_number': _phoneController.text,
          'date_of_birth': _dobController.text,
          'address': _addressController.text,
        }),
      );

      // Process the response
      if (response['status'] == 'success') {
        success = true;
        if (mounted) {
          // Update local state
          setState(() {
            email = _emailController.text;
            phoneNumber = _phoneController.text;
            dateOfBirth = _dobController.text;
            address = _addressController.text;
          });
        }
      } else {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      // Close the dialog
      Navigator.of(dialogContext).pop();
      // Show success message if update succeeded
      if (success) {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      }
    }
  }

  // Function to build form fields
  Widget _buildFormField(String label, TextEditingController controller,
      {bool isDate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: isDate,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: label,
            suffixIcon: isDate
                ? IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          controller.text =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: Navbar(),
    bottomNavigationBar: const BottomNavbar(),
    backgroundColor: const Color(0xFFFDF1E6), // Light peach background
    body: SingleChildScrollView(
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Page Title
              const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Profile Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black26,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              menuItem('See Menu Plans', Icons.menu_book),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              menuItem('See Wishlist', Icons.favorite),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Account Details Section
              Container(
                padding: const EdgeInsets.all(20),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE4B3), Color(0xFFFFD0B3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _detailField('Email:', email),
                    _detailField('Phone Number:', phoneNumber),
                    _detailField('Date of Birth:', dateOfBirth),
                    _detailField('Address:', address),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _openEditForm, // Open Edit Form
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Edit Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement delete account logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add spacing below the container
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
  }

  Widget menuItem(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 18),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _detailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Text(value.isNotEmpty ? value : '-'),
          ),
        ],
      ),
    );
  }
}
