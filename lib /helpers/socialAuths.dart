import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuth {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  googleAuth({required authProvider, required context}) async {
    await _handleGoogleSignOut();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    print('sign in accoutn >> $googleSignInAccount');
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    print('access token ${googleSignInAuthentication.accessToken}');
    log('idToken ${googleSignInAuthentication.idToken.toString()}');
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
    print('user $user');
    if (googleSignInAuthentication.idToken != null) {
      return googleSignInAuthentication.idToken.toString();
    }

    return;
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {}
  }
}
