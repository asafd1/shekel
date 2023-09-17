import 'package:flutter/material.dart';

import '../model/user.dart';
import '../model/transaction.dart' as shekel;

class ChildView extends StatelessWidget {
  final User child;
  final List<shekel.Transaction> transactions;

  static const currency = '₪';
  
  const ChildView(
      {super.key,
      required this.child,
      required this.transactions,});

  Widget _buildListView() {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions available.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Text('$currency${transaction.amount}');
      },
    );
  }
  
  Widget transactionsWidget() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: _buildListView()
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
            child: Text('$currency${child.balance}'),
          ),
          transactionsWidget(),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))
        ],
      ),
    );
  }
}
