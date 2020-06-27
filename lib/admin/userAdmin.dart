import 'package:firebase_auth/firebase_auth.dart';

class UserAdmin{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

   UserAdmin(FirebaseUser user){
     currentUser = user;
  }

  String userName() {
    if (currentUser != null) {
      if (currentUser.displayName == null) {
        return currentUser.email.replaceAll('@gmail.com', '');
      }
      return currentUser.displayName;
    } else {
      return "";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "Guest User";
    }
  }

  bool isAdmin(){
     if(email() == "admin@gas.mail.com") {
       return true;
     } else {
       return false;
     }
  }
}