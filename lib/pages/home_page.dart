import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/pages/child_view.dart';
import 'package:shekel/pages/family_view.dart';
import 'package:shekel/pages/login.dart';
import 'package:shekel/pages/role_choice.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/authentication.dart';
import 'package:shekel/util/user_identity.dart';

class HomePageWidget extends StatefulWidget {
  final String? familyId;

  const HomePageWidget(
    this.familyId, {
    super.key,
  });

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final Authentication _authentication = Authentication();
  String? username;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DefaultService service = AppState().service;

    FirebaseCrashlytics.instance.log("Starting sign-in process");

    // Handle login and navigate to the appropriate home screen
    return FutureBuilder<UserIdentity?>(
      future: _authentication.signInSilently(),
      builder: (BuildContext context, AsyncSnapshot<UserIdentity?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // navigate to login page
          FirebaseCrashlytics.instance.recordError(snapshot.error, null,
              reason: 'failed to sign in silently');
          return const LoginPageWidget();
        }

        FirebaseCrashlytics.instance
            .log("Done sign-in process. snapshot.data: '${snapshot.data}'");

        UserIdentity? signedInUser = snapshot.data;
        if (signedInUser == null) {
          return const LoginPageWidget();
        }

        return _getHomeScreen(service, signedInUser);
      },
    );
  }

  Widget _getHomeScreen(DefaultService service, UserIdentity signedInUser) {
    FirebaseCrashlytics.instance.log("Getting home screen");

    return FutureBuilder(
        future: service.getUser(signedInUser.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            FirebaseCrashlytics.instance.recordError(snapshot.error, null,
                reason: 'failed to get user');
            throw snapshot.error!;
          }

          User? user = snapshot.data;
          // user not found in db, create it, first in memory and once I get the role choice, in db 
          user ??= User(id: signedInUser.id, username: signedInUser.username, firstName: signedInUser.firstName, lastName: signedInUser.lastName, image: signedInUser.image); 

          AppState().signedInUser = user;

          // this is a new user. all existing users have a familyId
          if (user.familyId == null) {
            FirebaseCrashlytics.instance
                .log("Navigating to RoleChoicePageWidget");
            return RoleChoicePageWidget(user);
          }

          if (user.role == Role.child) {
            FirebaseCrashlytics.instance.log("Navigating to ChildViewWidget");
            return ChildViewWidget(user);
          } else {
            FirebaseCrashlytics.instance.log("Navigating to FamilyViewWidget");
            return FamilyViewWidget(user);
          }
        });
  }
}
