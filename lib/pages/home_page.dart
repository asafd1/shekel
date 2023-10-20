import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/pages/child_view.dart';
import 'package:shekel/pages/family_view.dart';
import 'package:shekel/pages/login.dart';
import 'package:shekel/pages/role_choice.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/util/oauth_user.dart';

class HomePageWidget extends StatefulWidget {
  final String? familyId;

  const HomePageWidget(this.familyId, {super.key,});

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
    DefaultService service = AppState().service;

    // Handle login and navigate to the appropriate home screen
    return FutureBuilder<OAuthUser?>(
      future: _googleAuth.signInSilently(),
      builder: (BuildContext context, AsyncSnapshot<OAuthUser?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // TODO: open login page
          throw snapshot.error!;
        }

        OAuthUser? signedInUser = snapshot.data;
        if (signedInUser == null) {
          return const LoginPageWidget();
        }

        return _getHomeScreen(service, signedInUser);
      },
    );
  }

 Widget _getHomeScreen(DefaultService service, OAuthUser signedInUser) {
    return FutureBuilder(
      future: service.getUser(signedInUser.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          throw snapshot.error!;
        }
        
        User? user = snapshot.data;
        user ??= service.createUser(id: signedInUser.id,
                                    familyId: widget.familyId,
                                    username: signedInUser.username,
                                    firstName: signedInUser.firstName,
                                    lastName: signedInUser.lastName,
                                    image: signedInUser.image,
                                    role: Role.parent);
        AppState().signedInUser = user;
        if (user.familyId == null) {
          return RoleChoicePageWidget(user);
        }
        
        if (user.role == Role.child) {
          return ChildViewWidget(user);
        } else {
          return FamilyViewWidget(user);
        }
      }
    );
  }
}