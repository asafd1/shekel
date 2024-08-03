import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/authentication.dart';

class ShekelDrawer extends StatelessWidget {
  final User? user;
  const ShekelDrawer(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Drawer(
        child: Text('No user'),
      );
    }
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user!.firstName),
            accountEmail: Text(user!.username),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user!.image ?? ''),
            ),
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.edit),
          //   title: const Text('Edit'),
          //   onTap: () {
          //     // Handle "Edit" action
          //   },
          // ),
          user!.role == 
            Role.parent ? ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Family'),
              onTap: () {
                AppState().goto(Routes.familyForm, user:user!);
              },
            ) : 
            const SizedBox.shrink(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              AppState().signedInUser = null;
              Authentication().signOut().then((value) => Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false));
            },
          ),
        ],
      ),
    );
  }
}