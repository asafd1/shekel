// custom app bar with leading icon and one action
// Compare this snippet from lib/widgets/transaction_form.dart:
import 'package:flutter/material.dart';
import 'package:shekel/util/authentication.dart';

import '../model/user.dart';

class ShekelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title = 'Shekel';
  final List<Widget> actions = <Widget>[];
  final User? user;

  ShekelAppBar({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    // final Reference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('gs://shekel-41250.appspot.com/family.jpg');

    actions.add(
      IconButton(
        icon: const Icon(Icons.person),
        tooltip: 'Profile',
        onPressed: () {
          // Handle sign out action
          // Navigator.pop(context); // Close the bottom sheet
        },
      ),
    );
    actions.add(
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Sign Out',
        onPressed: () {
          // Handle sign out action
          // Navigator.pop(context); // Close the bottom sheet
          GoogleAuth().signOut();
        },
      ),
    );
    return AppBar(
      title: Text(title),
      actions: actions,
      // leading icon
      leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.network('https://firebasestorage.googleapis.com/v0/b/shekel-41250.appspot.com/o/family.jpg?alt=media&token=771ffe74-0c38-4b2f-9d9a-ad66c6911225'),
          ),
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}