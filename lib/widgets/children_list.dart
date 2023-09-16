import 'package:flutter/material.dart';
import 'package:shekel/widgets/user_tile.dart';

import '../model/user.dart';

class ChildrenListWidget extends StatelessWidget {
  final List<User> children = const [];

  const ChildrenListWidget(
      {super.key,
      required List<User> children,
      required Function() onAddChildPressed,
      required Function() onRemoveChildPressed,
      required Function() onCreateTransaction,});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const Center(
        child: Text('No users available.'),
      );
    } else {
      return ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          final user = children[index];
          return UserListTile(
            username: user.firstName,
            balance: user.balance,
            onAddCurrencyPressed: () {
              // Implement logic to add money to the child's balance
            },
            onRemoveCurrencyPressed: () {
              // Implement logic to remove money from the child's balance
            },
            onRemoveUserPressed: () {
              // Implement logic to remove the child
            },
          );
        },
      );
    }   
  }
}
