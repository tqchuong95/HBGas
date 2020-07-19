// ========================== LoginPage ===============================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gasgasapp/screens/signupPage.dart';
import 'package:gasgasapp/ui/homepage.dart';
import 'package:gasgasapp/firebaseDB/userManagement.dart';
import 'package:gasgasapp/firebaseDB/googleSignIn.dart';
import 'package:gasgasapp/firebaseDB/facebookSignIn.dart';
import 'package:gasgasapp/admin/adminPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _resetKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseUser currentUser;
  Animation animation, delayAnimation, muchDelayedAnimation;
  AnimationController animationController;
  UserManagement userManagement = UserManagement();

  bool loading = false;
  bool hidePass = true;
  bool isLogedin = false;
  bool isLogedinAdmin = false;

  // Google sign in
  Auth auth = Auth();

// Google sign in
  // Facebook sign in
  AuthFb authFb = AuthFb();

// Facebook sign in

  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(curve: Curves.fastOutSlowIn, parent: animationController),
    );
    delayAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    isSignedIn();
    _loadCurrentUser();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });

    await firebaseAuth.currentUser().then((user) {
      if (user != null) {
        if (user.email == "admin@gas.mail.com") {
          setState(() => isLogedinAdmin = true);
        } else {
          setState(() => isLogedin = true);
        }
      }
    });
    if (isLogedin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()));
    }

    if (isLogedinAdmin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    }

    setState(() {
      loading = false;
    });
  }

  void _loadCurrentUser() {
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "Guest User";
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.5, 0.8],
                colors: [
                  Colors.cyanAccent,
                  Colors.tealAccent,
                ],
              ),
            ),
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      alignment: Alignment.center,
                      child: Image(
                          fit: BoxFit.fill,
                          width: 100.0,
                          height: 100.0,
                          image: AssetImage(
                            'images/logogas.png',
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        "Đăng nhập",
                        style: _loginRegStyles(),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        delayAnimation.value * width, 0.0, 0.0),
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.alternate_email,
                                    color: Colors.blueGrey),
                                hintText: "Email",
                                labelStyle: TextStyle(
                                    // color: Colors.white,
                                    ),
                                labelText: "Email"),
                            // ignore: missing_return
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Vui lòng nhập email";
                              }
//                              return "";
                            },
                            onSaved: (val) {
                              _emailController.text = val;
                            },
                            autocorrect: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            // obscureText:hidepass we toggle when user clicks the icon
                            obscureText: hidePass,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hidePass = false;
                                    });
                                  },
                                ),
                                hintText: "Password",
                                labelText: "Mật khẩu"),
                            // ignore: missing_return
                            validator: (val) {
                              if (val.length < 6) {
                                return "Mật khẩu ít nhất phải có 6 ký tự";
                              } else if (val.isEmpty) {
                                return "Mật khẩu không thể rỗng!";
                              }
//                              return "";
                            },
                            onSaved: (val) {
                              _passwordController.text = val;
                            },
                            autocorrect: true,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          //  ================== Login Btn =======================
                          Transform(
                            transform: Matrix4.translationValues(
                                muchDelayedAnimation.value * width, 0.0, 0.0),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0)),
                              minWidth: MediaQuery.of(context).size.width,
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    "Đăng nhập".toUpperCase(),
                                    style: _btnStyle(),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                print("login btn clicked!");
                                signIn();
                              },
                              color: Color(0xFFB33771),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Transform(
                            transform: Matrix4.translationValues(
                                muchDelayedAnimation.value * width, 0.0, 0.0),
                            child: Container(
                              child: InkWell(
                                onTap: () async {
                                  _showFormDialog();
                                },
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFFB33771),
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 5.0),
                          Transform(
                            transform: Matrix4.translationValues(
                                muchDelayedAnimation.value * width, 0.0, 0.0),
                            child: Container(
                              child: Text(
                                "Không có tài khoản?!",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      minWidth: MediaQuery.of(context).size.width,
                      child: ListTile(
                        title: Center(
                          child: Text(
                            "Đăng ký".toUpperCase(),
                            style: _btnStyle(),
                          ),
                        ),
                      ),
                      onPressed: () {
                        print("Register btn clicked!");
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      color: Color(0xFFB33771),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          "HOẶC",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 5.0,
                  ),
                  //  ================== Signin with Google Btn =======================

                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      minWidth: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: Image.asset(
                          "images/google.png",
                          height: 30.0,
                        ),
                        title: Text(
                          "Đăng nhập bằng Google".toUpperCase(),
                          style: _btnStyle(),
                        ),
                      ),
                      onPressed: () async {
                        _showLoadingIndicator();
                        FirebaseUser user = await auth.googleSignIn();
                        if (user != null) {
                          // user.sendEmailVerification();
                          userManagement.createUser(user.uid, {
                            "userId": user.uid,
                            "username": user.displayName,
                            "photoUrl": user.photoUrl,
                            "email": user.email,
                          });
//                                   Navigator.of(context).pushReplacement(
//                                       MaterialPageRoute(
//                                           builder: (context) => HomePage()));
                          // pushAndRemoveUtil makes users to not see the login screen when they press the back button

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()),
                            (Route<dynamic> route) => true,
                          );
                        }
                      },
                      color: Colors.redAccent,
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  //  ================== Signin with Facebook Btn =======================

                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      minWidth: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: Image.asset(
                          "images/facebook.png",
                          height: 30.0,
                        ),
                        title: Text(
                          "Đăng nhập bằng Facebook".toUpperCase(),
                          style: _btnStyle(),
                        ),
                      ),
                      onPressed: () async {
                        _showLoadingIndicator();
                        FirebaseUser user = await authFb.facebookSignIn();
                        if (user != null) {
                          // user.sendEmailVerification();
                          userManagement.createUser(user.uid, {
                            "userId": user.uid,
                            "username": user.displayName,
                            "photoUrl": user.photoUrl,
                            "email": user.email,
                          });
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) => HomePage()));
                          // pushAndRemoveUtil makes users to not see the login screen when they press the back button

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()),
                            (Route<dynamic> route) => true,
                          );
                        }
                      },
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _loginRegStyles() {
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 18.0,
      letterSpacing: 0.8,
      color: Color(0xFFB33771),
    );
  }

  Future signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoadingIndicator();

      try {
        if (_emailController.text == "admin") {
          await firebaseAuth.signInWithEmailAndPassword(
              email: "admin@gas.mail.com", password: _passwordController.text);
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (context) => HomePage()));
          // pushAndRemoveUtil makes users to not see the login screen when they press the back button
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
            (Route<dynamic> route) => true,
          );
        } else {
          await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()),
            (Route<dynamic> route) => true,
          );
        }
      } catch (e) {
        print(e.message);
        _showLoginError();
      }
    }
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: ListTile(
        title: Text(
            "Password mới đã được gửi tới email ${email()} của bạn. Vui lòng kiểm tra nó."),
        subtitle: Form(
          child: TextFormField(
            key: _resetKey,
            autovalidate: true,
            controller: _emailController,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email, color: Colors.blueGrey),
              hintText: "Vui lòng nhập email",
              labelText: "Email",
            ),
            // ignore: missing_return
            validator: (val) {
              if (val.isEmpty) {
                return "Vui lòng cung cấp email";
              }
//              return "";
            },
            onSaved: (val) {
              _emailController.text = val;
            },
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Hủy"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Gửi"),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  BuildContext loginContext;

  _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        loginContext = context;
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 20.0,
              ),
              Text("Loading!")
            ],
          ),
        );
      },
    );
  }

  _showLoginError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Lỗi đăng nhập'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tài khoản hoặc mật khẩu không đúng.'),
                Text('Vui lòng thử lại!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(loginContext).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
