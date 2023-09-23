import 'package:flutter/material.dart';
import 'package:shekel/widgets/child_tile.dart';

import '../model/user.dart';
import '../util/util.dart' as util;
import 'child_form.dart';

class ChildrenListWidget extends StatelessWidget {
  final List<User> children;
  final Function(String username, String firstname, String lastname, String? image) addChild;
  final Function(String userId) onRemoveChildPressed;
  final Function(String userId, num amount) onCreateTransaction;

  const ChildrenListWidget(
      {super.key,
      required this.children,
      required this.addChild,
      required this.onRemoveChildPressed,
      required this.onCreateTransaction,});

  @override
  Widget build(BuildContext context) {
    return util.listWithTitleAndButton('Children', children, _tileBuilder, _addChildButton(context, 'Add Child'));
  }

  Widget _addChildButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildForm(onSubmit: addChild)),
            );
        },
      child: Text(text),
    );
  }

  Widget _tileBuilder(user){
    return ChildListTile(
      child: user,
      onAddCurrencyPressed: (amount) {
        onCreateTransaction(user.id, amount);
      },
      onRemoveCurrencyPressed: (amount) {
        onCreateTransaction(user.id, amount * -1);
      },
      onRemoveUserPressed: () {
        onRemoveChildPressed(user.id);
      },
    );
  }
}
