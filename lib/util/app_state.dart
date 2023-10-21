import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';

class AppState extends ChangeNotifier {
  User? _signedInUser;
  DefaultService? _service;
  GlobalKey<NavigatorState>? _navigatorKey;
  List<User> _children = [];

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

  void updateChild(User child) {
    // find child by id
    _children.firstWhere((element) => element.id == child.id).update(child);
    notifyListeners();
  }

  void updateChildBalance(String childId, num amount) {
    // find child by id
    _children.firstWhere((element) => element.id == childId).balance += amount;
    notifyListeners();
  }

  void setChildren(List<User> children) {
    _children = children;
  }

  User getChild(String childId) => _children.firstWhere((element) => element.id == childId);
}