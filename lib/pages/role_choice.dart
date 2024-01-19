import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';
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
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                _createFamily();
              },
              child: const Text('Parent', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(
              height: 10.0,
            ),
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
                  _createChild(familyId);
                  // AppState().service.updateUser(widget.user);
                  // Navigator.popAndPushNamed(context, Routes.childView,
                  //     arguments: {"user": widget.user});
                });
              },
              child: const Text('Child', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }

  void _createChild(String familyId) {
    widget.user.role = Role.child;
    widget.user.familyId = familyId;
    _createUser(widget.user);
    // AppState().goto(Routes.familyView, user: widget.user);
    Navigator.popAndPushNamed(context, Routes.childView, arguments: {"user": widget.user});
  }

  void _createFamily() {
    DefaultService service = AppState().service;

    widget.user.role = Role.parent;
    service.createFamily(widget.user.lastName).then((family) {
      widget.user.familyId = family.id;
      _createUser(widget.user);
      // AppState().goto(Routes.familyView, user: widget.user);
      Navigator.popAndPushNamed(context, Routes.familyView, arguments: {"user": widget.user});
    });
  }

  void _createUser(user) {
    DefaultService service = AppState().service;

    FirebaseCrashlytics.instance.log("Creating user");
    service.createUser(
        id: user.id,
        familyId: user.familyId,
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        image: user.image,
        role: user.role);
    FirebaseCrashlytics.instance.log("User created successfully");
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
