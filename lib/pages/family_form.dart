import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/util.dart';

class FamilyFormWidget extends StatefulWidget {
  final User parent;

  const FamilyFormWidget(this.parent, {super.key});

  @override
  FamilyFormWidgetState createState() => FamilyFormWidgetState();
}

class FamilyFormWidgetState extends State<FamilyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late final DefaultService _service;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _imageUrlController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<DefaultService>(context, listen: false);

    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: [
          Title(
              color: Colors.blue,
              child: const Text('Add Family', style: TextStyle(fontSize: 30))),
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
              if (value != null && value.isNotEmpty && !isValidUrl(value)) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _onSubmit(
                  _nameController.text,
                  _imageUrlController.text.trim().isEmpty
                      ? null
                      : _imageUrlController.text,
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onSubmit(String familyName, String? familyImage) {
    _service.createFamily(familyName, familyImage).then((family) {
      widget.parent.familyId = family.id;
      _service.updateUser(widget.parent);
      Navigator.pop(context, family);
    });
  }
}
