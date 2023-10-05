import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/authentication.dart';

class ShekelDrawer extends StatelessWidget {
  final User user;
  const ShekelDrawer(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.firstName),
            accountEmail: Text(user.username),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.image ?? ''),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              // Handle "Edit" action
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              GoogleAuth().signOut().then((value) => Navigator.pushNamed(context, Routes.login));
            },
          ),
        ],
      ),
    );
  }
}