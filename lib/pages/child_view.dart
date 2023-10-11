import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/scaffold.dart';
import 'package:shekel/widgets/transactions_list.dart';

import '../model/user.dart';

class ChildViewWidget extends StatefulWidget {
  final User child;

  const ChildViewWidget(
    this.child, {
    super.key,
  });

  @override
  State<ChildViewWidget> createState() => _ChildViewWidgetState();
}

class _ChildViewWidgetState extends State<ChildViewWidget> {
  final currency = '₪';

  @override
  Widget build(BuildContext context) {
    return ShekelScaffold(
      Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              child: widget.child.image != null
                  ? Image.network(widget.child.image!)
                  : const Icon(Icons.person_2_outlined),
            ),
            Text(
              widget.child.firstName,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            // SizedBox(width: 10.0),
            Text(
              '${NumberFormat('#,###').format(widget.child.balance)} $currency',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        TransactionsListWidget(widget.child.id, _updateUserBalance, readonly: AppState().signedInUser!.role != Role.parent),
      ]),
    );
  }

  _updateUserBalance(num amount) {
    setState(() {
      widget.child.balance += amount;
    });
  }
}
