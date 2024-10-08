import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/util/remote_config.dart';
import 'package:shekel/widgets/scaffold.dart';
import 'package:shekel/widgets/transactions_list.dart';

import '../model/user.dart';

class ChildViewWidget extends StatefulWidget {
  final User child;

  const ChildViewWidget(
    this.child, {
    super.key,
  });

  @override
  State<ChildViewWidget> createState() => _ChildViewWidgetState();
}

class _ChildViewWidgetState extends State<ChildViewWidget> {
  final String currency = RemoteConfig().getReviewMode() ? '\$' : '₪';

  @override
  Widget build(BuildContext context) {
    Role role = AppState().signedInUser!.role;

    User child = role == Role.parent
        ? Provider.of<AppState>(context).getChild(widget.child.id)
        : widget.child;
    return ShekelScaffold(
      Column(children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: 50.0,
                  child: child.image != null
                      ? Image.network(child.image!)
                      : const Icon(Icons.person_2_outlined),
                ),
              ),
              Text(
                child.firstName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              // SizedBox(width: 10.0),
              Text(
                '${NumberFormat('#,###').format(child.balance)} $currency',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Flexible(
            flex: 3,
            child: TransactionsListWidget(child.id,
                readonly: role != Role.parent)),
      ]),
    );
  }
}
