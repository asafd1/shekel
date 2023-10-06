import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/pages/child_view.dart';
import 'package:shekel/pages/family_form.dart';
import 'package:shekel/pages/family_view.dart';
import 'package:shekel/pages/login.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
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

  @override
  Widget build(BuildContext context) {
    DefaultService service = AppState.service(context);

    return FutureBuilder(
      future: _googleAuth.signInSilently(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        if (snapshot.data == null) {
          return const LoginPageWidget();
        }

        return _getHomeView(service);
      },
    );
  }

 Widget _getHomeView(DefaultService service) {
    username = _googleAuth.getUsername();

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
          AppState.setSignedInUser(context, user);
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
}