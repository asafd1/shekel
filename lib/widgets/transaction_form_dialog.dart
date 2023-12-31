import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFormDialog extends StatefulWidget {
  const TransactionFormDialog({super.key});

  @override
  TransactionFormDialogState createState() => TransactionFormDialogState();
}

class TransactionFormDialogState extends State<TransactionFormDialog> {
  static final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController =
      TextEditingController(text: formatter.format(DateTime.now()));

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 5.0),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 5.0),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date',
            ),
            keyboardType: TextInputType.datetime,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _dateController.text = formatter.format(picked);
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final amount = double.parse(_amountController.text);
            final description = _descriptionController.text;
            final datetime = _parseDate(_dateController.text);

            final transaction = {
              "amount": amount,
              "description": description,
              "datetime": datetime,
            };

            Navigator.pop(context, transaction);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  DateTime? _parseDate(String date) {
    try {
      final now = DateTime.now();
      final picked = formatter.parse(date);
      return DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
        now.second,
      );
    } catch (e) {
      return null;
    }
  }
}
