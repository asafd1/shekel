import 'package:flutter/material.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/widgets/child_tile.dart';

class ChildrenListWidget extends StatelessWidget {
  final Family family;

  const ChildrenListWidget(
    this.family,
      {super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Stretch children horizontally
      children: [
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Children',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        _listView(family.children),
        _addChildButton(context),
      ],
    );
  }

  Widget _addChildButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.childForm, arguments: family);
      },
      child: const Text('Add Child'),
    );
  }

  Widget _listView(list) {
  if (list.isEmpty) {
    return const Center(
      child: Text('Nothing here.'),
    );
  }

  return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ChildListTile(list[index]);
        },
    ); 
  } 
}
