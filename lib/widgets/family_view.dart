import 'package:flutter/material.dart';

import '../model/family.dart';
import '../model/user.dart';
import 'children_list.dart';

class FamilyViewWidget extends StatelessWidget {
  final Family family;
  final Function(String username, String firstname, String lastname, String? image) onAddChildPressed;
  final Function(String userId) onRemoveChildPressed;
  final Function(String userId, int amount) onCreateTransaction;

  static const String defaultImageUrl =
      'https://t4.ftcdn.net/jpg/00/25/45/59/360_F_25455932_RWRLbbdaJfvfRv0yFvWW2A8r38Xv7U4O.jpg';

  const FamilyViewWidget(
      {super.key,
      required this.family,
      required this.onAddChildPressed,
      required this.onRemoveChildPressed,
      required this.onCreateTransaction});

  Widget childrenWidget(List<User> children) {
    return Scaffold(
      body: ChildrenListWidget(
          children: children,
          onAddChildPressed: onAddChildPressed,
          onRemoveChildPressed: onRemoveChildPressed,
          onCreateTransaction: onCreateTransaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            family.imageUrl ?? defaultImageUrl,
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${family.name} Family',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                  child: Text("ParentsWidget(family.parents)"),
                ),
                const SizedBox(
                  height: 18.0,
                  child: Text("ChildrenWidget(family.parents)"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
