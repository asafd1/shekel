import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shekel/util/remote_config.dart';
import 'package:shekel/util/user_identity.dart';

class Authentication {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  static final Authentication _singleton = Authentication._internal();

  factory Authentication() {
    return _singleton;
  }

  Authentication._internal();

  Future<UserIdentity> _signIn({bool silently = false}) async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = silently
        ? await _googleSignIn.signInSilently()
        : await _googleSignIn.signIn();

    // if (googleUser == null && silently) {
    //   googleUser = await _googleSignIn.signIn();
    // }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final firebase.OAuthCredential credential =
        firebase.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await showBiometricsPinCodeScreen();
    } catch (e) {
      throw Exception("Biometric authentication failed");
    }

    // Once signed in, return the username
    return await _auth
        .signInWithCredential(credential)
        .then((userCredential) =>
            UserIdentity.fromOAuthUser(userCredential.user!))
        .catchError((error) {
      _googleSignIn.signOut();
      _auth.signOut();
      throw Exception("Authentication failed");
    });
  }

  Future<UserIdentity> signIn() async {
    return await _signIn();
  }

  Future<UserIdentity> signInUsernamePassword(String username, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return UserIdentity.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserIdentity?> signInSilently() async {
    if (RemoteConfig().getReviewMode()) {
      User? user = FirebaseAuth.instance.currentUser;
      return user != null ? UserIdentity.fromFirebaseUser(user) : null;
    }
    return await _signIn(silently: true);
  }

  String? getUsername() {
    return _googleSignIn.currentUser?.email;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> showBiometricsPinCodeScreen() async {
    final localAuth = LocalAuthentication();

    await localAuth.stopAuthentication();
    // Check if biometric authentication is available.
    final isAvailable = await localAuth.canCheckBiometrics;
    if (!isAvailable) {
      // local authentication is not available. allow user to continue.
      return;
    }

    final biometrics = await localAuth.getAvailableBiometrics();
    if (biometrics.isEmpty) {
      // no biometrics are available. allow user to continue.
      return;
    }

    // Authenticate the user.
    final isAuthenticated = await localAuth.authenticate(
      localizedReason: "Shekel requires biometric authentication to continue",
    );

    if (!isAuthenticated) {
      throw Exception("Local Authentication failed");
    }
  }

  // Future<bool> verifyUserPassword(String username, String password) async {
  //   if (_md5(password) == '5d7525dd719ea3b5372f5e7937db64ea') {
  //     _isUserAuthenticated = true;
  //     return true;
  //   }
  //   return false;
  // }

  // String _md5(String s) {
  //   var bytes = utf8.encode(s); // Convert string to bytes
  //   var digest = md5.convert(bytes); // Calculate MD5 hash
  //   return digest.toString(); // Convert digest to string
  // }
}
