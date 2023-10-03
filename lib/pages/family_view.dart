import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/widgets/app_bar.dart';
import 'package:shekel/widgets/children_list.dart';

import '../model/user.dart';

class FamilyViewWidget extends StatelessWidget {
  final User user;

  static const String defaultImageUrl =
      'https://lh3.googleusercontent.com/a/ACg8ocLrlGobYpUGMnINyj5dFfxCzBQPNEEOLMVBkrr0LKkaocQ=s288-c-no';

  const FamilyViewWidget(
    this.user, {
    super.key,
  });

  Widget childrenWidget(Family family) {
    return Container(
      // constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: ChildrenListWidget(family),
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
    DefaultService service = Provider.of<DefaultService>(context, listen: false);

    return FutureBuilder<Family>(
      future: service.getFamily(user.familyId!),
      builder: (BuildContext context, AsyncSnapshot<Family> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          throw snapshot.error!;
        }
        return _getFamilyView(snapshot.data!);
      },
    );
  }

  Widget _getFamilyView(Family family) {

    return Scaffold(
      appBar: ShekelAppBar(user: user),
      body: Column(
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
                childrenWidget(family),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
