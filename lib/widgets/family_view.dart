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
    return Container(
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: ChildrenListWidget(
          children: children,
          onAddChildPressed: onAddChildPressed,
          onRemoveChildPressed: onRemoveChildPressed,
          onCreateTransaction: onCreateTransaction),
      
    );
  }

  Widget parentsWidget(List<User> parents) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: const Text('parentsWidget'),
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
            child: Image.network(
            family.imageUrl ?? defaultImageUrl,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          )),
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
                parentsWidget(family.parents),
                childrenWidget(family.children),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
