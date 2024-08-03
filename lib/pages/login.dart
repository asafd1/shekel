import 'package:flutter/material.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/util/remote_config.dart';
import 'package:shekel/widgets/scaffold.dart';

TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
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
            ? _login(context)
            : const CircularProgressIndicator(),
      ),
    );
  }

  Column _login(context) {
    if (RemoteConfig().getReviewMode()) {
      return _userPasswordLogin(context);
    } else {
      return _googleLogin(context);
    }
  }

  Column _userPasswordLogin(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _inProgress = true;
            });

            String username = _usernameController.text;
            String password = _passwordController.text;

            // Replace this with your own authentication logic
            Authentication().signInUsernamePassword(username, password).then((user) {
                Navigator.popAndPushNamed(context, Routes.home);
            }).onError((error, stackTrace) {
              setState(() {
                _inProgress = false;
              });
              // Optionally show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login error: $error')),
              );
            });
          },
          child: _inProgress
              ? const CircularProgressIndicator()
              : const Text('Login'),
        ),
        const SizedBox(height: 20),
        const Text('Please enter your username and password to log in.'),
      ],
    );
  }

  Column _googleLogin(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _inProgress = true;
            });

            Authentication().signIn().then((user) {
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
              Image.asset('assets/images/google.png', height: 24, width: 24),
              const SizedBox(width: 10),
              const Text('Login with Google'),
            ],
          ),
        ),
        const SizedBox(
            height: 20), // Add some space between the button and the text
        const Text('You need a Google account in order to use Shekel'),
      ],
    );
  }
}
