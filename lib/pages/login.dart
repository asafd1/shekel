import 'package:flutter/material.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/widgets/app_bar.dart';

class LoginPageWidget extends StatelessWidget {
  const LoginPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShekelAppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              GoogleAuth().signIn().then((username) {
                Navigator.popAndPushNamed(context, Routes.home);
              });
            },
            child: const Text('Login'),
          ),
      ),
    );
  }
}