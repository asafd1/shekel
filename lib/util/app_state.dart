import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';

class AppState {
  User? _signedInUser;
  DefaultService? _service;
  GlobalKey<NavigatorState>? _navigatorKey;

  // Singleton instance
  static final AppState _instance = AppState._internal();

  factory AppState() => _instance;

  AppState._internal();

  Future<void> init(FirebaseApp app) async {
    _service = DefaultService(app);
    _navigatorKey = GlobalKey<NavigatorState>();
  }  

  get service => _service;

  get signedInUser => _signedInUser;
  set signedInUser(signedInUser) => _signedInUser = signedInUser;

  void goto(String routeName, {Map<String, dynamic>? arguments}) {
    _navigatorKey!.currentState!.push(
      Routes.generateRoute(
        RouteSettings(
          name: routeName,
          arguments: arguments,
        ),
      ),
    );
  }
}