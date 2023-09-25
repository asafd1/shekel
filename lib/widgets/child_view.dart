import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/service/default_service.dart';

import '../model/user.dart';
import '../model/transaction.dart' as shekel;
import '../util/util.dart' as util;

class ChildView extends StatefulWidget {
  final User child;

  final currency = '₪';

  final Function? addCurrency;
  final Function? removeCurrency;

  const ChildView({
    super.key,
    required this.child,
    this.addCurrency,
    this.removeCurrency,
  });

  @override
  State<ChildView> createState() {
    return ChildViewState();
  }
}

class ChildViewState extends State<ChildView> {
  late Future<List<shekel.Transaction>> transactions;
  final List<IconButton> _buttons = [];

  @override
  void initState() {
    super.initState();

    if (widget.addCurrency != null) {
      _buttons.add(IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _addTransaction(Icons.add);
          // widget.addCurrency!(1);
        }
      ));
    }
    if (widget.removeCurrency != null) {
      _buttons.add(IconButton(
        icon: const Icon(Icons.remove),
        onPressed: () {
          _addTransaction(Icons.remove);
          // widget.removeCurrency!(1);
        },
      ));
    }
  }

  Widget _transactionTile(transaction) {
    return Text('${widget.currency}${transaction.amount}');
  }

  Widget _transactionsWidget() {
    transactions = Provider.of<DefaultService>(context, listen: false)
        .getTransactions(widget.child.id, 10);
    return Container(
      constraints: const BoxConstraints(maxHeight: 600, minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 243, 33, 177), // Border color
          width: 2.0, // Border width
        ),
      ),
      child: util.loadWidgetAsync(
          future: transactions,
          widgetBuilder: (transactions) => util.listWithTitleAndButtons(
              title: '${widget.currency}${widget.child.balance}',
              list: transactions,
              tileBuilder: _transactionTile,
              buttons: _buttons)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.username),
      ),
      body: Column(
        children: [
          _transactionsWidget(),
          // IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))
        ],
      ),
    );
  }
  
  void _addTransaction(IconData iconData) {
    
  }
}
