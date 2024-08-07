import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/transaction.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/transaction_form_dialog.dart';
import 'package:shekel/widgets/transaction_tile.dart';

class TransactionsListWidget extends StatefulWidget {
  final String childId;
  final bool readonly;

  const TransactionsListWidget(
    this.childId, {
    super.key,
    this.readonly = true,
  });

  @override
  State<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}

class _TransactionsListWidgetState extends State<TransactionsListWidget> {
  late DefaultService service;
  List<Transaction> transactions = [];

  int limit = 100;

  @override
  Widget build(BuildContext context) {
    service = AppState().service;

    return Column(
      children: [
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              widget.readonly ? Container() : _addTransactionButton(context),
            ],
          ),
        ),
        _listView(transactions),
      ],
    );
  }

  Widget _addTransactionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const TransactionFormDialog(),
        ).then((input) {
          if (input == null) {
            return;
          }
          service.createTransaction(widget.childId, input["amount"],
              input["description"], input["datetime"]);
          Provider.of<AppState>(context, listen: false)
              .updateChildBalance(widget.childId, input["amount"]);
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _listView(list) {
    return FutureBuilder(
        future: service.getTransactions(widget.childId, limit),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            throw snapshot.error!;
          }

          return _getListWidget(snapshot.data);
        });
  }

  _getListWidget(List<Transaction> transactions) {
    final listViewHeight = MediaQuery.of(context).size.height * 0.6;

    if (transactions.isEmpty) {
      return SizedBox(
          height: listViewHeight,
          child: const Center(
            child: Text('Nothing here.'),
          ));
    }

    return SizedBox(
      height: listViewHeight,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionListTile(
            transactions[index],
            widget.readonly ? null : _removeTransaction,
          );
        },
      ),
    );
  }

  _removeTransaction(Transaction transaction) {
    service.removeTransaction(transaction.id);
    Provider.of<AppState>(context, listen: false)
        .updateChildBalance(widget.childId, -transaction.amount);
  }
}
