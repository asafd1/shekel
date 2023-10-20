import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/scaffold.dart';

class RoleChoicePageWidget extends StatefulWidget {
  final User user;

  const RoleChoicePageWidget(this.user, {super.key});

  @override
  State<RoleChoicePageWidget> createState() => _RoleChoicePageWidgetState();
}

class _RoleChoicePageWidgetState extends State<RoleChoicePageWidget> {
  final _familyIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ShekelScaffold(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "I am a",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,),
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () {
                  Navigator.pushNamed(context, Routes.familyForm, arguments: {"user": widget.user});
              },
              child: const Text('Parent', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: () async {
                  // show modal to enter family id
                  final String? familyId = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => _selectFamilyDialog(context),
                  );
                  if (familyId == null) {
                    return;
                  }
                  // update user family id
                  AppState().service.isFamilyExists(familyId).then((exists) {
                    if (!exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Family not found'),
                        ),
                      );
                      return;
                    }
                    widget.user.familyId = familyId;
                    AppState().service.updateUser(widget.user);
                    Navigator.popAndPushNamed(context, Routes.childView, arguments: {"user": widget.user});
                  });
              },
              child: const Text('Child', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectFamilyDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Family ID'),
      content: TextField(
            controller: _familyIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Family ID',
            ),
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final String familyId = _familyIdController.text;
            Navigator.pop(context, familyId);
          },
          child: const Text('Select'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _familyIdController.dispose();
    super.dispose();
  }
}