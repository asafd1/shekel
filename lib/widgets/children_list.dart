import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/child_tile.dart';

class ChildrenListWidget extends StatefulWidget {
  final Family family;

  const ChildrenListWidget(
    this.family, {
    super.key,
  });

  @override
  State<ChildrenListWidget> createState() => _ChildrenListWidgetState();
}

class _ChildrenListWidgetState extends State<ChildrenListWidget> {
  late DefaultService service;

  @override
  Widget build(BuildContext context) {
    service = AppState().service;

    return Column(
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
        _listView(widget.family.children),
      ],
    );
  }

  Widget _listView(list) {
    Provider.of<AppState>(context, listen: false).setChildren(list);
    if (list.isEmpty) {
      return const Center(
        child: Text('Nothing here.'),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        // shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ChildListTile(list[index], _removeChild);
        },
      ),
    );
  }

  _removeChild(String userId) {
    setState(() {
      widget.family.children.removeWhere((child) => child.id == userId);
      service.removeUser(userId);
    });
  }
}
