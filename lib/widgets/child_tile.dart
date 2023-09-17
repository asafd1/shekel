import 'package:flutter/material.dart';
import 'package:shekel/model/transaction.dart';

import '../model/user.dart';
import 'child_view.dart';

class ChildListTile extends StatelessWidget {
  final User child;
  final String currency;
  final Function() onAddCurrencyPressed;
  final Function() onRemoveCurrencyPressed;
  final Function() onRemoveUserPressed;

  const ChildListTile({
    super.key,
    required this.child,
    this.currency = '₪',
    required this.onAddCurrencyPressed,
    required this.onRemoveCurrencyPressed,
    required this.onRemoveUserPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(child.username),
      subtitle: Row(children: [
        Text('$currency${child.balance}'),
        SizedBox(
          width: 16.0,
          child: IconButton(
            onPressed: onAddCurrencyPressed,
            icon: const Icon(Icons.add, size: 16.0),
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: 16.0,
          child: IconButton(
            onPressed: onRemoveCurrencyPressed,
            icon: const Icon(Icons.remove, size: 16.0),
            color: Colors.red,
          ),
        ),
      ]),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22.0,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildView(
                          child: child,
                          transactions: [Transaction(child.id, 10), Transaction(child.id, 20)],
                    )
                  ));},
              icon: const Icon(Icons.view_agenda, size: 20.0),
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 16.0,
            child: IconButton(
              onPressed: onRemoveUserPressed,
              icon: const Icon(Icons.delete, size: 20.0),
              color: const Color.fromARGB(255, 243, 33, 93),
            ),
          ),
        ],
      ),
    );
  }
}
