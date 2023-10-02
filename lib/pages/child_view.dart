import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/widgets/app_bar.dart';

import '../model/user.dart';
import '../model/transaction.dart' as shekel;

class ChildViewWidget extends StatefulWidget {
  final User child;

  final currency = '₪';

  const ChildViewWidget(this.child, {
    super.key,
  });

  @override
  State<ChildViewWidget> createState() {
    return ChildViewWidgetState();
  }
}

class ChildViewWidgetState extends State<ChildViewWidget> {
  late Future<List<shekel.Transaction>> transactions;

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
      // child: _transactionTile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShekelAppBar(),
      body:_transactionsWidget(),
    );
  }

  void _addTransaction(IconData iconData) {
    
  }
}
