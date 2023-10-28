import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shekel/util/oauth_user.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  static final GoogleAuth _singleton = GoogleAuth._internal();

  factory GoogleAuth() {
    return _singleton;
  }

  GoogleAuth._internal();

  Future<OAuthUser> _signIn({bool silently = false}) async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = silently
        ? await _googleSignIn.signInSilently()
        : await _googleSignIn.signIn();

    if (googleUser == null && silently) {
      googleUser = await _googleSignIn.signIn();
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
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
        .then((userCredential) => OAuthUser(userCredential.user!));
  }

  Future<OAuthUser> signIn() async {
    return await _signIn();
  }

  Future<OAuthUser?> signInSilently() async {
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
}
