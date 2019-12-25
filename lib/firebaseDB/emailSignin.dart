import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthEmail {
  Future<FirebaseUser> emailSignIn(String email, String password);

  Future<FirebaseUser> emailSignUp(email, password);
}

class AuthEmail implements BaseAuthEmail {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> emailSignUp(email, password) async {
    try {
      FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<FirebaseUser> emailSignIn(String email, String password) async {
    try {
      FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
