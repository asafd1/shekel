import 'package:flutter/material.dart';

import '../model/family.dart';
import '../model/user.dart';

class FamilyViewWidget extends StatelessWidget {
  final Family family;
  
  static const String defaultImageUrl = 'https://t4.ftcdn.net/jpg/00/25/45/59/360_F_25455932_RWRLbbdaJfvfRv0yFvWW2A8r38Xv7U4O.jpg';

  const FamilyViewWidget({super.key, required this.family});

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


