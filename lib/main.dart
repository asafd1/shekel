import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/util/app_state.dart';
import 'firebase_options.dart';

import 'package:shekel/service/default_service.dart';
import 'package:shekel/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  // var sharedPreferences = await SharedPreferences.getInstance();
  runApp(Provider(
    create: (context) => AppState(service: DefaultService(app)),
    child: const AppMain(),
    )
  );
}

class AppMain extends StatelessWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // scaffoldBackgroundColor: const Color.white[50],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
