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
        child: !_inProgress
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _inProgress = true;
                      });

                      GoogleAuth().signIn().then((username) {
                        Navigator.popAndPushNamed(context, Routes.home);
                      }).onError((error, stackTrace) {
                        setState(() {
                          _inProgress = false;
                        });
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/google.png',
                            height: 24, width: 24),
                        const SizedBox(width: 10),
                        const Text('Login with Google'),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          20), // Add some space between the button and the text
                  const Text(
                      'You need a Google account in order to use Shekel'),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
