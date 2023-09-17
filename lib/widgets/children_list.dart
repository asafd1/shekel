import 'package:flutter/material.dart';
import 'package:shekel/widgets/child_tile.dart';

import '../model/user.dart';

class ChildrenListWidget extends StatelessWidget {
  final List<User> children;
  final Function(String username, String firstname, String lastname, String? image) onAddChildPressed;
  final Function(String userId) onRemoveChildPressed;
  final Function(String userId, int amount) onCreateTransaction;

  const ChildrenListWidget(
      {super.key,
      required this.children,
      required this.onAddChildPressed,
      required this.onRemoveChildPressed,
      required this.onCreateTransaction,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onAddChildPressed('username_${DateTime.now().millisecondsSinceEpoch}', 'firstname', 'lastname', null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserListView() {
    if (children.isEmpty) {
      return const Center(
        child: Text('No users available.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) {
        final user = children[index];
        return UserListTile(
          username: user.firstName,
          balance: user.balance,
          onAddCurrencyPressed: () {
            onCreateTransaction(user.id, 10);
          },
          onRemoveCurrencyPressed: () {
            onCreateTransaction(user.id, -10);
          },
          onRemoveUserPressed: () {
            onRemoveChildPressed(user.id);
          },
        );
      },
    );
  }
}
