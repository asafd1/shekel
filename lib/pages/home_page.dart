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
import 'package:shekel/util/oauth_user.dart';

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
  final GoogleAuth _googleAuth = GoogleAuth();
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
    return FutureBuilder<OAuthUser?>(
      future: _googleAuth.signInSilently(),
      builder: (BuildContext context, AsyncSnapshot<OAuthUser?> snapshot) {
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

        OAuthUser? signedInUser = snapshot.data;
        if (signedInUser == null) {
          return const LoginPageWidget();
        }

        return _getHomeScreen(service, signedInUser);
      },
    );
  }

  Widget _getHomeScreen(DefaultService service, OAuthUser signedInUser) {
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

          FirebaseCrashlytics.instance.log("Creating user");

          User? user = snapshot.data;
          user ??= service.createUser(
              id: signedInUser.id,
              familyId: widget.familyId,
              username: signedInUser.username,
              firstName: signedInUser.firstName,
              lastName: signedInUser.lastName,
              image: signedInUser.image,
              role: Role.parent);
          FirebaseCrashlytics.instance.log("User created successfully");

          AppState().signedInUser = user;
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
