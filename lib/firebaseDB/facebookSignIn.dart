import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class BaseAuthFb {
  Future<FirebaseUser> facebookSignIn();
}

class AuthFb implements BaseAuthFb {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> facebookSignIn() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final facebookLoginResult = await facebookLogin.logIn(['email']);

    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token);
      try {
        AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        return user;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
    return null;
  }
}
