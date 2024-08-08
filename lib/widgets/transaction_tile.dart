import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shekel/model/transaction.dart';
import 'package:shekel/util/remote_config.dart';
import 'package:shekel/util/util.dart';

class TransactionListTile extends StatefulWidget {
  final Transaction transaction;
  final String currency = RemoteConfig().getReviewMode() ? '\$' : '₪';

  final Function? _removeTransaction;

  TransactionListTile(
    this.transaction,
    this._removeTransaction, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TransactionListTileState();
}

class TransactionListTileState extends State<TransactionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.transaction.amount > 0
          ? const Icon(
              Icons.add,
              color: Colors.green,
            )
          : const Icon(
              Icons.remove,
              color: Colors.red,
            ),
      title: Text(
        '${widget.currency}${NumberFormat('#,###').format(widget.transaction.amount.abs())}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Row(children: [
        Text(
          widget.transaction.description,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          DateFormat('yyyy-MM-dd').format(widget.transaction.createdAt),
          style: const TextStyle(
            fontSize: 12.0,
          ),
        ),
      ]),
      trailing: widget._removeTransaction == null ?
        const SizedBox(width: 1,) :
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            bool userConfirmed = await showDeleteConfirmation(
                context, 'Are you sure you want to delete this transaction?');
            if (userConfirmed) {
              await widget._removeTransaction!(widget.transaction);
            }
          }),
    );
  }
}
