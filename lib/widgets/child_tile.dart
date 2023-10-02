import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';

import '../model/user.dart';

class ChildListTile extends StatefulWidget {
  final User child;
  final String currency = '₪';

  const ChildListTile(
    this.child, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ChildListTileState();
}

class ChildListTileState extends State<ChildListTile> {
  late DefaultService service;

  @override
  Widget build(BuildContext context) {
    service = Provider.of<DefaultService>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.child.image ?? ''),
      ),
      title: Text(
        widget.child.username,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text(
        '${widget.currency}${widget.child.balance.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.transactions,
            arguments: widget.child);
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeChild(widget.child.id),
      ),
    );
  }

  _removeChild(String userId) {
    setState(() {
      service.removeUser(userId);
    });
  }
}
