import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';

class TransactionsWidget extends StatefulWidget {
  final User child;
  const TransactionsWidget(this.child, {super.key});

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}