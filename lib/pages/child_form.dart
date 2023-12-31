import 'package:flutter/material.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/util.dart';
import 'package:shekel/widgets/scaffold.dart';

class ChildFormWidget extends StatefulWidget {
  final Family family;

  const ChildFormWidget(this.family, {super.key,});

  @override
  ChildFormWidgetState createState() => ChildFormWidgetState();
}

class ChildFormWidgetState extends State<ChildFormWidget> {
  late DefaultService service;

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

  @override
  Widget build(BuildContext context) {
    service = AppState().service;

    return ShekelScaffold(
      Form(
        key: _formKey,
        child: Column(
          children: [
            Title(color: Colors.blue, child: const Text('Add Child', style: TextStyle(fontSize: 30))),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a user email';
                }
                if (!isValidEmail(value)) {
                  return 'User name must be a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _firstnameController,
              decoration: const InputDecoration(hintText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(hintText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(hintText: 'Image URL'),
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
                  User user = createUser(
                    _usernameController.text,
                    _firstnameController.text,
                    _lastnameController.text,
                    _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text,
                  );
                  Navigator.pop(context, user);
                }
              },
              child: const Text('Submit'),
            ),
            // IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))
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

  User createUser(String username, String firstname, String lastname, String? image) {
    return service.createUser(username: username, id: '1', role: Role.child, firstName: firstname, lastName: lastname, familyId: widget.family.id, image: image);
  }
}
