// custom app bar with leading icon and one action
// Compare this snippet from lib/widgets/transaction_form.dart:
import 'package:flutter/material.dart';

import '../model/user.dart';

class ShekelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title = 'Shekel';
  final List<Widget> actions = <Widget>[];
  final User? user;

  ShekelAppBar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    actions.add(
      IconButton(
        icon: const Icon(Icons.person),
        tooltip: 'Profile',
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
    if (Navigator.canPop(context)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      );
    }
    return AppBar(
      title: Text(title),
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
