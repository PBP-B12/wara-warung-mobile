import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:wara_warung_mobile/screens/savedmenu.dart';
import 'package:wara_warung_mobile/screens/wishlistpage.dart';
import 'package:wara_warung_mobile/widgets/navbar.dart';
import 'package:wara_warung_mobile/widgets/bottomnavbar.dart';
import 'dart:convert';
import 'package:wara_warung_mobile/screens/logind.dart';

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
    final response = await request.get(
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/user_dashboard/get-user-dashboard-data/");

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
          title: Text(
            'Edit Details',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  _saveChanges(context), // Pass the dialog's context
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: Text(
                'Save Changes',
                style: GoogleFonts.poppins(color: Colors.white),
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
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/user_dashboard/update-user/",
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

  void _deleteAccount(BuildContext context) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.postJson(
        "https://jeremia-rangga-warawarung.pbp.cs.ui.ac.id/user_dashboard/delete/",
        jsonEncode({}),
      );

      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account deleted successfully.")),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginApp()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to delete account: ${response['message']}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
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
          style: GoogleFonts.poppins(
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
            Text(
              'My Account',
              style: GoogleFonts.poppins(
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
                  Text(
                    'Welcome,',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    username,
                    style: GoogleFonts.poppins(
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SavedMenuPage()),
                                );
                              },
                              child:
                                  menuItem('Saved Menu Plans', Icons.menu_book),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WishlistPage(
                                            menu_id: -1,
                                          )),
                                );
                              },
                              child: menuItem('Saved Wishlist', Icons.favorite),
                            )
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  Text(
                    'Account Details',
                    style: GoogleFonts.poppins(
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
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Distribusi tombol secara merata
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: _openEditForm, // Open Edit Form
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Edit Details',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Jarak antar tombol
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            // Show a confirmation dialog before deleting the account
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete your account? This action cannot be undone."),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Cancel",
                                          style: GoogleFonts.poppins(
                                              color: Colors.red)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        _deleteAccount(
                                            context); // Call the delete account method
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent),
                                      child: Text("Delete",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Delete Account',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
          style: GoogleFonts.poppins(
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
            style: GoogleFonts.poppins(
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
