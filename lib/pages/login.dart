import 'package:flutter/material.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/widgets/app_bar.dart';

class LoginPageWidget extends StatelessWidget {
  final Function(String) onLogin;
  const LoginPageWidget(this.onLogin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShekelAppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              GoogleAuth().signIn().then((username) {
                // onLogin != null ? onLogin!(username) : Navigator.pop(context);
                Navigator.popAndPushNamed(context, Routes.home);
              });
                //(username) => Navigator.popAndPushNamed(context, Routes.home, arguments: username));
            },
            child: const Text('Login'),
          ),
      ),
    );
  }

  // Widget _loginWidget() {
  //   GoogleAuth googleAuth = GoogleAuth();

  //   return FutureBuilder(
  //     future: googleAuth.isSignedIn(),
  //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //       if (snapshot.connectionState != ConnectionState.done) {
  //         return const CircularProgressIndicator();
  //       }
  //       if (snapshot.requireData) { // user is signed in
  //         Navigator.popAndPushNamed(context, Routes.home);
  //         return Container();
  //       } else { // user is not signed in
  //         return ElevatedButton(
  //           onPressed: () {
  //             googleAuth.signIn().then(
  //               (username) => Navigator.popAndPushNamed(context, Routes.home, arguments: username));
  //           },
  //           child: const Text('Login'),
  //         );
  //       }
  //     },
  //   );
  // }
}