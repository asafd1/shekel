import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shekel/widgets/family_form.dart';
import 'package:shekel/widgets/family_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'model/user.dart';
import 'service/default_service.dart';
import 'util/util.dart';

const familyIdKey = 'familyId';
const userIdKey = 'userId';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  var sharedPreferences = await SharedPreferences.getInstance();
  runApp(AppMain(DefaultService(app), sharedPreferences));
}

class AppMain extends StatefulWidget {
  final DefaultService _service;
  final SharedPreferences _sharedPreferences;

  const AppMain(this._service, this._sharedPreferences, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppMainState();
  }
}

class _AppMainState extends State<AppMain> {
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _familyId = widget._sharedPreferences.getString(familyIdKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shekel',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _getHomeWidget(),
    );
  }

  _createFamily(String name, String? image) {
    setState(() {
      widget._service.createFamily(name, image).then((family) {
        widget._sharedPreferences.setString(familyIdKey, family.id);
        _familyId = family.id;
      });
    });
  }

  _addChild(String username, String firstname, String lastname, String? image) {
    setState(() {
      widget._service.createUser(
          _familyId!, Role.child, username, firstname, lastname, image);
    });
  }

  _removeChild(String userId) {
    setState(() {
      widget._service.removeUser(userId);
    });
  }

  _createTransaction(String userId, num amount) {
    setState(() {
      widget._service.createTransaction(userId, amount);
    });
  }

  Widget _getHomeWidget() {
    if (_familyId != null) {
      return loadWidgetAsync(
          widget._service.getFamily(_familyId!),
          (family) => FamilyViewWidget(
              family: family,
              addChild: _addChild,
              onRemoveChildPressed: _removeChild,
              onCreateTransaction: _createTransaction));
    } else {
      return FamilyFormWidget(
        onSubmit: (name, image) => {_createFamily(name, image)},
      );
    }
  }
}
