import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/remote_config.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  await RemoteConfig().initialize();
  
  errorConfig();
  
  AppState().init(app);

  // var sharedPreferences = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const AppMain(),
    )
  );
}

void errorConfig() {
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };  
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
      navigatorKey: AppState().navigatorKey,
    );
  }
}
