import 'package:flutter/material.dart';
import 'package:shekel/routes/routes.dart';

import '../model/user.dart';

class ChildListTile extends StatefulWidget {
  final User child;
  final String currency = '₪';

  final Function _removeChild;

  const ChildListTile(
    this.child,
    this._removeChild, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ChildListTileState();
}

class ChildListTileState extends State<ChildListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: widget.child.image != null
            ? CircleAvatar(backgroundImage: NetworkImage(widget.child.image!))
            : const Icon(Icons.person),
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
        trailing: SizedBox(
              width: 100,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => Navigator.pushNamed(
                        context, Routes.childView,
                        arguments: {"user": widget.child})),
                // const Spacer(),
                IconButton(
                  padding: const EdgeInsets.only(right: 0),
                  icon: const Icon(Icons.delete),
                  onPressed: () => widget._removeChild(widget.child.id),
                ),
              ])),
        );
  }
}
