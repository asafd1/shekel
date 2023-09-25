import 'package:flutter/material.dart';
import 'package:shekel/model/transaction.dart' as shekel;

class TransactionListTile extends StatefulWidget {
  final shekel.Transaction transaction;
  final String currency;
  final Function(num amount) addCurrency;
  final Function(num amount) removeCurrency;
  
  final bool editMode;

  const TransactionListTile({
    super.key,
    required this.transaction,
    this.currency = '₪',
    required this.addCurrency,
    required this.removeCurrency,
    this.editMode = false,
  });

  @override
  State<StatefulWidget> createState() => TransactionListTileState();
}

class TransactionListTileState extends State<TransactionListTile> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
            widget.transaction.amount.toStringAsFixed(2),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.transaction.createdAt}}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: _amountController,
            //         keyboardType: TextInputType.number,
            //         onChanged: (value) {
            //           setState(() {
            //             _canAdd = double.tryParse(value) != null &&
            //                 double.parse(value) != 0;
            //           });
            //         },
            //         decoration: const InputDecoration(
            //           hintText: '0.0',
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.add),
            //       onPressed: _canAdd
            //           ? () {
            //               // Handle adding money here
            //               double amount = double.parse(_amountController.text);
            //               setState(() {
            //                 widget.child.balance += amount;
            //                 _amountController.clear();
            //                 _canAdd = false;
            //               });
            //             }
            //           : null,
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.remove),
            //       onPressed: _canAdd
            //           ? () {
            //               // Handle subtracting money here
            //               double amount = double.parse(_amountController.text);
            //               setState(() {
            //                 widget.child.balance -= amount;
            //                 _amountController.clear();
            //                 _canAdd = false;
            //               });
            //             }
            //           : null,
            //     ),
            //   ],
            // ),
          ],
        ),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.delete),
        //       onPressed: widget.onRemoveUserPressed,
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.visibility),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => ChildView(child: widget.child, 
        //                                               addCurrency: widget.onAddCurrencyPressed,
        //                                               removeCurrency: widget.onRemoveCurrencyPressed,)
        //           )
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
