import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/util/authentication.dart';

import 'package:shekel/widgets/family_form.dart';
import 'package:shekel/widgets/family_view.dart';

import 'firebase_options.dart';
import 'model/family.dart';
import 'model/user.dart';
import 'service/default_service.dart';
import 'util/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  // var sharedPreferences = await SharedPreferences.getInstance();
  GoogleAuth googleAuth = GoogleAuth();
  String username = await googleAuth.signIn();
  runApp(Provider(
      create: (context) => DefaultService(app), child: AppMain(username)));
}

class AppMain extends StatefulWidget {
  // final SharedPreferences _sharedPreferences;
  final String _username;

  const AppMain(this._username, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppMainState();
  }
}

class _AppMainState extends State<AppMain> {
  User? _user;
  Family? _family;

  @override
  void initState() {
    super.initState();
  }

  // _service getter
  DefaultService get _service => Provider.of<DefaultService>(context, listen: false);

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
      home: _getHomeWidgetAsync(),
    );
  }

  _addChild(String username, String firstname, String lastname, String? image) {
    setState(() {
      _service.createUser(
          _family!.id, Role.child, username, firstname, lastname, image);
    });
  }

  _removeChild(String userId) {
    setState(() {
      _service.removeUser(userId);
    });
  }

  _createTransaction(String userId, num amount) {
    setState(() {
      _service.createTransaction(userId, amount);
    });
  }

  Future<Family?> _getFamily(String username) async {
    User? user = await _service.getUserByUsername(username);
    if (user != null) {
      _family = await _service.getFamily(user.familyId);
      return _family;
    }
    return Future.value(null);
  }
  
  Widget _getHomeWidget(data) {
    if (_family == null) {
      return FamilyFormWidget(
        onSubmit: (name, image) async {
          _family = await _service.createFamily(name, image);
          setState(() {
            _user ??= _service.createUser(_family!.id, Role.parent, widget._username, '', '', null);
          });
        },
      );
    }
    return FamilyViewWidget(
            family: _family!,
            addChild: _addChild,
            onRemoveChildPressed: _removeChild,
            onCreateTransaction: _createTransaction); 
  }

  Widget _getHomeWidgetAsync() {
    return loadWidgetAsync(
        future: _getFamily(widget._username),
        widgetBuilder: (data) => _getHomeWidget(data));
  }
}

