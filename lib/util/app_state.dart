import 'package:provider/provider.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/service/default_service.dart';

class AppState {
  User? _signedInUser;
  final DefaultService _service;

  AppState({required service}) : _service = service;

  static DefaultService service(context) => Provider.of<AppState>(context, listen: false)._service;
  static User setSignedInUser(context, User user) => Provider.of<AppState>(context, listen: false)._signedInUser = user;
  static User? getSignedInUser(context) => Provider.of<AppState>(context, listen: false)._signedInUser;
}