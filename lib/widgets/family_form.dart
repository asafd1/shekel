import 'package:flutter/material.dart';

class FamilyFormWidget extends StatefulWidget {
  final String? initialName;
  final String? initialImageUrl;
  final Function(String name, String? imageUrl) onSubmit;

  const FamilyFormWidget({super.key, 
    this.initialName,
    this.initialImageUrl,
    required this.onSubmit,
  });

  @override
  FamilyFormWidgetState createState() => FamilyFormWidgetState();
}

class FamilyFormWidgetState extends State<FamilyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _imageUrlController =
        TextEditingController(text: widget.initialImageUrl);
  }

  _isValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Title(color: Colors.blue, child: const Text('Add Family', style: TextStyle(fontSize: 30))),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Family Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a family name';
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
                    _nameController.text,
                    _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text,
                  );
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
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
