import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shekel/model/transaction.dart';

import '../model/user.dart';
import '../util/util.dart';
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
  TextEditingController amountController = TextEditingController();

  num amount = 0.0;

  @override
  void initState() {
    amountController.addListener(() {
      amount = num.tryParse(amountController.text) ?? 0.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.child.username),
      subtitle: Row(children: [
        Text('${widget.currency}${widget.child.balance}'),
        Container(
            constraints: const BoxConstraints(maxHeight: 20, minHeight: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue, // Border color
                width: 2.0, // Border width
              ),
            ),
            child: SizedBox(
              width: 32.0,
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                controller: amountController,
                decoration: const InputDecoration(hintText: '0.0'),
                validator: (value) {
                  if (value != null && value.isNotEmpty && !isValidUrl(value)) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
            )),
        SizedBox(
          width: 32.0,
          child: IconButton(
            onPressed: amount != 0 ? () => widget.onAddCurrencyPressed(amount) : null,
            icon: const Icon(Icons.add, size: 16.0),
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: 32.0,
          child: IconButton(
            onPressed:
                amount != 0 ? () => widget.onRemoveCurrencyPressed(amount) : null,
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
                              child: widget.child,
                              transactions: [
                                Transaction(widget.child.id, 10),
                                Transaction(widget.child.id, 20)
                              ],
                            )));
              },
              icon: const Icon(Icons.view_agenda, size: 20.0),
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 16.0,
            child: IconButton(
              onPressed: widget.onRemoveUserPressed,
              icon: const Icon(Icons.delete, size: 20.0),
              color: const Color.fromARGB(255, 243, 33, 93),
            ),
          ),
        ],
      ),
    );
  }
}
