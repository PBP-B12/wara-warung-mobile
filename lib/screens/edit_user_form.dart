import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key});

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _phoneNumber = "";
  String _dateOfBirth = "";
  String _address = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Profile"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onSaved: (value) => _email = value!,
                validator: (value) =>
                    value!.isEmpty ? "Email cannot be empty" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                onSaved: (value) => _phoneNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Date of Birth"),
                onSaved: (value) => _dateOfBirth = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Address"),
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Send POST request to Django
                    final response = await request.postJson(
                      "http://127.0.0.1:8000/update-flutter/",
                      jsonEncode({
                        'email': _email,
                        'phone_number': _phoneNumber,
                        'date_of_birth': _dateOfBirth,
                        'address': _address,
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("User profile updated successfully!")),
                        );
                        Navigator.pop(context); // Return to the previous page
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Failed to update profile. Please try again.")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
