import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shekel/model/family.dart';
import 'package:shekel/model/user.dart';
import 'package:shekel/service/default_service.dart';
import 'package:shekel/util/app_state.dart';
import 'package:shekel/widgets/children_list.dart';
import 'package:shekel/widgets/scaffold.dart';

class FamilyViewWidget extends StatelessWidget {
  final User parent;

  const FamilyViewWidget(
    this.parent, {
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
      future: service.getFamily(parent.familyId!),
      builder: (BuildContext context, AsyncSnapshot<Family?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || snapshot.data == null) {
          throw snapshot.error!;
        }
        return _getFamilyView(context, snapshot.data!);
      },
    );
  }

  Widget _getFamilyView(BuildContext context, Family family) {
    String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/shekel-41250.appspot.com/o/families%2Fno-image.png?alt=media&token=9bc28d73-ebf3-4a3c-b109-97e6aee83eeb';

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
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                      onPressed: () => generateInviteLink(context),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                        alignment: Alignment.centerLeft,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.blue.withOpacity(0.2)),
                      ),
                      child: const Text(
                        'Copy Invite Link',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // parentsWidget(family.parents),
          const SizedBox(
            height: 5,
          ),
          childrenWidget(family),
        ],
      ),
    );
  }

  void generateInviteLink(BuildContext context) {
    // insert string to clipboard
    String inviteLink =
        'https://asafdavid.com/shekel/pages/childForm?familyId=${parent.familyId}';
    Clipboard.setData(ClipboardData(text: inviteLink));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invite link copied to clipboard'),
      ),
    );
  }
}
