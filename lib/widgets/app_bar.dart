// custom app bar with leading icon and one action
// Compare this snippet from lib/widgets/transaction_form.dart:
import 'package:flutter/material.dart';

import '../model/user.dart';

class ShekelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title = 'Shekel';
  final List<Widget> actions = <Widget>[];
  final User? user;

  ShekelAppBar(this.user, {super.key,});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      );
    }
    if (Navigator.canPop(context)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      );
    }
    return AppBar(
      title: Text(
        title, 
        style: const TextStyle(
          color: Colors.blueAccent,
          // fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
          fontSize: 18.0,
        ),
      ),
      actions: actions,
      // leading icon
      leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('assets/images/shekel.png'),
          ),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
