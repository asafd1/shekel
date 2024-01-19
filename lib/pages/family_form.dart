import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/util.dart' as util;
import 'package:shekel/widgets/scaffold.dart';

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
  File? _file;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _imageUrlController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parent.familyId == null) {
      return form(context);
    }

    return FutureBuilder<Family?>(
      future: AppState().service.getFamily(widget.parent.familyId!),
      builder: (BuildContext context, AsyncSnapshot<Family?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || snapshot.data == null) {
          throw snapshot.error!;
        }
        return form(context, family: snapshot.data);
      },
    );
  }

  Widget form(BuildContext context, {Family? family}) {
    const String title = 'Family Details';
    const String defaultImageUrl =
        'https://firebasestorage.googleapis.com/v0/b/shekel-41250.appspot.com/o/no-image.png?alt=media&token=d2ac82fc-402d-42a7-b302-0b037f9ab6b7';
        
    if (_file == null) {
      String imageUrl =
          family?.imageUrl == null ? defaultImageUrl : family!.imageUrl!;
      util.getFileByUri(imageUrl).then((f) {
        setState(() {
          _file = f;
        });
      });
    }

    return ShekelScaffold(
      Column(
        children: [
          Title(
              color: Colors.blue,
              child: const Text(title, style: TextStyle(fontSize: 30))),
          Center(
            child: GestureDetector(
              onTap: _selectFile,
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: _file == null
                      ? const Icon(Icons.file_upload)
                      : Image.file(
                          _file!,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Text(
              family?.name ?? AppState().signedInUser!.lastName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget form1(BuildContext context, {Family? family}) {
    final String title = family == null ? 'Add Family' : 'Update Family';

    return ShekelScaffold(Form(
      key: _formKey,
      child: Column(
        children: [
          Title(
              color: Colors.blue,
              child: Text(title, style: const TextStyle(fontSize: 30))),
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
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _selectFile,
            child: const Text('Select Image'),
          ),
          const SizedBox(height: 16.0),
          if (_file != null)
            Image(
              image: FileImage(_file!),
              height: 200.0,
            ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  !util.isValidUrl(value)) {
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
                    family: family);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ));
  }

  void _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onSubmit(String familyName, String? familyImage, {Family? family}) {
    if (family == null) {
      return _createFamily(familyName, familyImage);
    }

    family.name = familyName;
    family.imageUrl = familyImage;
    _updateFamily(family);
  }

  void _createFamily(String familyName, String? familyImage) {
    AppState().service.createFamily(familyName, familyImage).then((family) {
      widget.parent.familyId = family.id;
      widget.parent.role = Role.parent;
      AppState().service.updateUser(widget.parent);
      AppState().goto(Routes.familyView, user: widget.parent);
    });
  }

  void _updateFamily(Family family) {
    AppState().service.updateFamily(family).then((family) {
      AppState().goto(Routes.familyView, user: widget.parent);
    });
  }
}
