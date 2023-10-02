import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:shekel/service/default_service.dart';
import 'package:shekel/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  // var sharedPreferences = await SharedPreferences.getInstance();
  runApp(Provider(
      create: (context) => DefaultService(app), child: const AppMain()));
}

class AppMain extends StatelessWidget {
  const AppMain({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
      // routes: {
      //   Routes.login: (_) => const LoginPageWidget(),
      //   // Add other routes here
      // },
    );
  }

//   _removeChild(String userId) {
//     setState(() {
//       _service.removeUser(userId);
//     });
//   }

//   _createTransaction(String userId, num amount) {
//     setState(() {
//       _service.createTransaction(userId, amount);
//     });
//   }

//   Future<Family?> _getFamily(String username) async {
//     _user = await _service.getUserByUsername(username);
//     if (_user != null) {
//       _family = await _service.getFamily(_user!.familyId);
//       return _family;
//     }
//     return Future.value(null);
//   }
  
//   Widget _getHomeWidget(data) {
//     if (_family == null) {
//       return FamilyFormWidget(
//         onSubmit: (name, image) async {
//           _family = await _service.createFamily(name, image);
//           setState(() {
//             _user ??= _service.createUser(_family!.id, Role.parent, widget._username, '', '', null);
//           });
//         },
//       );
//     }
//     return FamilyViewWidget(
//             family: _family!,
//             user: _user!,
//             addChild: _addChild,
//             onRemoveChildPressed: _removeChild,
//             onCreateTransaction: _createTransaction); 
//   }

//   Widget _getHomeWidgetAsync() {
//     return loadWidgetAsync(
//         future: _getFamily(widget._username),
//         widgetBuilder: (data) => _getHomeWidget(data));
//   }
// }
}