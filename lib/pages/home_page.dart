import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/pages/child_view.dart';
import 'package:shekel/pages/family_form.dart';
import 'package:shekel/pages/family_view.dart';
import 'package:shekel/pages/login.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/authentication.dart';

class HomePageWidget extends StatefulWidget {  
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final GoogleAuth _googleAuth = GoogleAuth();
  String? username;

  @override
  void initState() {
    super.initState();
  }

  void _onLogin(String username) {
    setState(() {
      this.username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    DefaultService service = Provider.of<DefaultService>(context, listen: false);
    username = _googleAuth.getUsername();

    if (username == null) {
      return LoginPageWidget(_onLogin);
    }

    return FutureBuilder(
      future: service.getUserByUsername(username!), 
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          throw snapshot.error!;
        }
        
        if (snapshot.hasData) {
          User user = snapshot.data;
          return _childOrFamilyView(user);
        } else {
          User user = User(username: username, 
                           role: Role.parent);
          service.createUser(user);
          return FamilyFormWidget(user);
        }
      }
    );
  }

  Widget _childOrFamilyView(User user) {
    if (user.role == Role.child) {
      return ChildViewWidget(user);
    } else {
      return FamilyViewWidget(user);
    }
  }

  // Widget _loginWidget() {
  //   return ElevatedButton(
  //     onPressed: () {
  //       _googleAuth.signIn().then(
  //         (username) => Navigator.popAndPushNamed(context, Routes.home, arguments: username));
  //     },
  //     child: const Text('Login'),
  //   );
  // }
}