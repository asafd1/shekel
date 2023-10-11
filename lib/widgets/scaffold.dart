import 'package:flutter/material.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/app_bar.dart';
import 'package:shekel/widgets/end_drawer.dart';

class ShekelScaffold extends StatelessWidget {
  final Widget child;
  const ShekelScaffold(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    User? user = AppState().signedInUser;
    return Scaffold(
      endDrawer: ShekelDrawer(user),
      appBar: ShekelAppBar(user),
      body: child,
    );
  }
}