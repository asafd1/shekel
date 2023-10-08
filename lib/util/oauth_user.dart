import 'package:firebase_auth/firebase_auth.dart';

class OAuthUser {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? image;

  OAuthUser._({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory OAuthUser(User oauthUser) {
    return OAuthUser._(
      id: oauthUser.uid,
      username: oauthUser.email ?? oauthUser.providerData[0].email ?? oauthUser.uid,
      firstName: oauthUser.displayName?.split(' ')[0],
      lastName: oauthUser.displayName?.split(' ')[1],
      image: oauthUser.photoURL,
    );
  }
}