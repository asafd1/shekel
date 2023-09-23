import 'package:flutter/material.dart';

import '../model/user.dart';
import 'child_view.dart';

class ChildListTile extends StatefulWidget {
  final User child;
  final String currency;
  final Function(num amount) onAddCurrencyPressed;
  final Function(num amount) onRemoveCurrencyPressed;
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
  State<StatefulWidget> createState() => ChildListTileState();
}

class ChildListTileState extends State<ChildListTile> {
  final TextEditingController _amountController = TextEditingController();
  bool _canAdd = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          widget.child.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.currency}${widget.child.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _canAdd = double.tryParse(value) != null &&
                            double.parse(value) != 0;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: '0.0',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _canAdd
                      ? () {
                          // Handle adding money here
                          double amount = double.parse(_amountController.text);
                          setState(() {
                            widget.child.balance += amount;
                            _amountController.clear();
                            _canAdd = false;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _canAdd
                      ? () {
                          // Handle subtracting money here
                          double amount = double.parse(_amountController.text);
                          setState(() {
                            widget.child.balance -= amount;
                            _amountController.clear();
                            _canAdd = false;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onRemoveUserPressed,
            ),
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildView(child: widget.child),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
