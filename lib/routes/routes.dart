import 'package:flutter/material.dart';
import 'package:shekel/pages/child_form.dart';
import 'package:shekel/pages/child_view.dart';
import 'package:shekel/pages/family_form.dart';
import 'package:shekel/pages/family_view.dart';
import 'package:shekel/pages/home_page.dart';
import 'package:shekel/pages/login.dart';
import 'package:shekel/pages/transactions.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String familyView= '/family_view';
  static const String familyForm = '/family_form';
  static const String childView = '/child_view';
  static const String childForm = '/child_form';
  static const String transactions = '/transactions';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> valuePassed = {};
    if (settings.arguments != null) {
      valuePassed = settings.arguments as Map<String, dynamic>;
    }

    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePageWidget());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPageWidget());
      case familyView:
        return MaterialPageRoute(builder: (_) => FamilyViewWidget(valuePassed['user']));
      case familyForm:
        return MaterialPageRoute(builder: (_) => FamilyFormWidget(valuePassed['user']));
      case childView:
        return MaterialPageRoute(builder: (_) => ChildViewWidget(valuePassed['user']));
      case childForm:
        return MaterialPageRoute(builder: (_) => ChildFormWidget(valuePassed['family']));
      case transactions:
        return MaterialPageRoute(builder: (_) => TransactionsWidget(valuePassed['user']));
      default:
          throw FlutterError('No route defined for ${settings.name}');
    }
  }
}