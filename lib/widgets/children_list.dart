import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/routes/routes.dart';
import 'package:shekel/service/default_service.dart';
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
    service = Provider.of<DefaultService>(context, listen: false);

    return Column(
      children: [
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.family.children.length} Children',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              _addChildButton(context),
            ],
          ),
        ),
        _listView(widget.family.children),
      ],
    );
  }

  Widget _addChildButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, Routes.childForm,
            arguments: {"family": widget.family}).then((child) {
          if (child != null) {
            setState(() {
              widget.family.children.add(child as User);
            });
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _listView(list) {
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
