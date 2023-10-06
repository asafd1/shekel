import 'package:flutter/material.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/widgets/scaffold.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return ShekelScaffold(
      Center(
        child: !_inProgress ? 
          ElevatedButton(
            onPressed: () {
              setState(() {
                _inProgress = true;
              });
              GoogleAuth().signIn().then((username) {
                Navigator.popAndPushNamed(context, Routes.home);
              });
            },
            child: const Text('Login'),
          ) : 
          const CircularProgressIndicator(),
      ),
    );
  }
}