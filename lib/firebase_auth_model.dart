import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  void createUserWithEmailAndPassword(String email, String password) async {
    currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    notifyListeners();
  }

  void signInWithEmailAndPassword(String email, String password) async {
    currentUser = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    notifyListeners();
  }

  void signOut() async {
    await _firebaseAuth.signOut();
    currentUser = null;
    notifyListeners();
  }

//  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  Future<String> signInWithGoogle() async {
//    final GoogleSignInAccount account = await _googleSignIn.signIn();
//    final GoogleSignInAuthentication _auth = await account.authentication;
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: _auth.accessToken,
//      idToken: _auth.idToken,
//    );
//    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
//  }
//
//  Future<String> signInWithFacebook() async {
//    final result = await _facebookLogin.logInWithReadPermissions(['email']);
//
//    final AuthCredential credential = FacebookAuthProvider.getCredential(
//      accessToken: result.accessToken.token,
//    );
//    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
//  }
}
