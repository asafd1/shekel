import 'package:firebase_auth/firebase_auth.dart';

class UserIdentity {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? image;

  UserIdentity._({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory UserIdentity.fromOAuthUser(User oauthUser) {
    return UserIdentity._(
      id: oauthUser.uid,
      username: oauthUser.email ?? oauthUser.providerData[0].email ?? oauthUser.uid,
      firstName: oauthUser.displayName?.split(' ')[0],
      lastName: oauthUser.displayName?.split(' ')[1],
      image: oauthUser.photoURL,
    );
  }

  factory UserIdentity.fromFirebaseUser(User user) {
    return UserIdentity._(
      id: user.uid,
      username: user.email!,
      firstName: user.displayName!.split(' ')[0],
      lastName: user.displayName!.split(' ')[1],
    );
  }
}