import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/service/default_service.dart';

import '../model/user.dart';
import '../model/transaction.dart' as shekel;
import '../util/util.dart' as util;

class ChildView extends StatefulWidget {
  final User child;

  final currency = '₪';
  
  const ChildView(
      {super.key,
      required this.child,});

  @override
  State<ChildView> createState() {
    return ChildViewState();
  }
}

class ChildViewState extends State<ChildView> {
  late Future<List<shekel.Transaction>> transactions;
  @override
  void initState() {
    super.initState();
  }

  Widget _transactionTile(transaction) {
    return Text('${widget.currency}${transaction.amount}');
  }
  
  Widget _transactionsWidget() {
    transactions = Provider.of<DefaultService>(context, listen: false).getTransactions(widget.child.id, 10);
    return Container(
        constraints: const BoxConstraints(maxHeight: 200, minHeight: 100),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Border color
            width: 2.0, // Border width
          ),
        ),
        child: util.loadWidgetAsync(transactions, (transactions) => 
                                  util.listWithTitleAndButton('Transactions', 
                                  transactions, 
                                  _transactionTile, 
                                  ElevatedButton(onPressed: () => {}, child: const Text('Add')))),

      );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('${widget.currency}${widget.child.balance}'),
          ),
          _transactionsWidget(),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))
        ],
      ),
    );
  }
  
}
