import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class BaseAuthFb {
  Future<FirebaseUser> facebookSignIn();
}

class AuthFb implements BaseAuthFb {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  // ignore: missing_return
  Future<FirebaseUser> facebookSignIn() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final facebookLoginResult = await facebookLogin.logIn(['email']);

    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token);
      try {
        FirebaseUser user = await firebaseAuth.signInWithCredential(credential);
        return user;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }
}
