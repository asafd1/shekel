import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final String username;
  final int balance;
  final String currency;
  final Function() onAddCurrencyPressed;
  final Function() onRemoveCurrencyPressed;
  final Function() onRemoveUserPressed;
  

  const UserListTile({
    super.key,
    required this.username,
    required this.balance,
    this.currency = '₪',
    required this.onAddCurrencyPressed,
    required this.onRemoveCurrencyPressed,
    required this.onRemoveUserPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username),
      subtitle: Text('$currency$balance'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16.0,
            child: IconButton(
              onPressed: onAddCurrencyPressed,
              icon: const Icon(Icons.add, size: 16.0),
              color: Colors.green,
            ),
          ),
          SizedBox(width: 16.0,
            child: IconButton(
              onPressed: onRemoveCurrencyPressed,
              icon: const Icon(Icons.remove, size: 16.0),
              color: Colors.red,
            ),
          ),
          SizedBox(width: 16.0,
            child: IconButton(
              onPressed: onRemoveUserPressed,
              icon: const Icon(Icons.delete, size: 16.0),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
