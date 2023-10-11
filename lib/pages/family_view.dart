import 'package:flutter/material.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/children_list.dart';
import 'package:shekel/widgets/scaffold.dart';

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
    return SizedBox(
      height: 300,
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
    DefaultService service = AppState().service;

    return FutureBuilder<Family?>(
      future: service.getFamily(user.familyId!),
      builder: (BuildContext context, AsyncSnapshot<Family?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || snapshot.data == null) {
          throw snapshot.error!;
        }
        return _getFamilyView(snapshot.data!);
      },
    );
  }

  Widget _getFamilyView(Family family) {
    return ShekelScaffold(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.network(
                      family.imageUrl ?? defaultImageUrl,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                  ],
                ),
              ),
            ],
          ),
          // parentsWidget(family.parents),
          const SizedBox(height: 5,),
          childrenWidget(family),
        ],
      ),
    );
  }
}
