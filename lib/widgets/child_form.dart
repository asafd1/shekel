import 'package:flutter/material.dart';

class ChildForm extends StatefulWidget {
  final Function(String username, String firstname, String lastname, String? imageUrl) onSubmit;

  const ChildForm({super.key, 
    required this.onSubmit,
  });

  @override
  ChildFormState createState() => ChildFormState();
}

class ChildFormState extends State<ChildForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  _isValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Title(color: Colors.blue, child: const Text('Add Child', style: TextStyle(fontSize: 30))),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'User Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a user email';
                }
                if (!_isValidEmail(value)) {
                  return 'User name must be a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value != null && value.isNotEmpty && !_isValidUrl(value)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(
                    _usernameController.text,
                    _firstnameController.text,
                    _lastnameController.text,
                    _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
