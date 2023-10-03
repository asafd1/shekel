import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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


  Future<String> _signIn({bool silently = false}) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = silently ? await _googleSignIn.signInSilently() : await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the username
    return await _auth.signInWithCredential(credential).then((userCredential) => userCredential.user!.email!);
  }

  Future<String> signIn() async {
    return await _signIn();
  }

  Future<String?> signInSilently() async {
    return await _signIn(silently: true);
  }
  
  String? getUsername() {
    return _googleSignIn.currentUser?.email;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}