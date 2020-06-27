import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BaseAuthEmail {
  Future<FirebaseUser> emailSignIn(String email, String password);

  Future<FirebaseUser> emailSignUp(email, password);
}

class AuthEmail implements BaseAuthEmail {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> emailSignUp(email, password) async {
    try {
      AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (signUpError) {
      if(signUpError is PlatformException) {
        if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          Fluttertoast.showToast(
            msg: "Tài khoản đã được sử dụng.",
            toastLength: Toast.LENGTH_LONG,
          );
          return null;
        }
      }
    }
    return null;
  }

  @override
  Future<FirebaseUser> emailSignIn(String email, String password) async {
    try {
      AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
