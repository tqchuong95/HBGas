import 'package:flutter/material.dart';
import 'package:gasgasapp/screens/loginPage.dart';
import 'package:gasgasapp/ui/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gasgasapp/firebaseDB/userManagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gasgasapp/firebaseDB/emailSignin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  AuthEmail authEmail = AuthEmail();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserManagement userManagement = UserManagement();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  Animation animation, delayAnimation, muchDelayedAnimation;
  AnimationController animationController;
  bool hidePass = true;
  SharedPreferences preferences;
  bool isLoading = false;
  bool isLoggedIn = false;
  BuildContext dialogContext;

  @override
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
  }

  void isSignedIn() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    final width = MediaQuery.of(context).size.width;

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
                  InkWell(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Transform(
                      transform: Matrix4.translationValues(
                          animation.value * width, 0.0, 0.0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Text(
                          "SignUp".toUpperCase(),
                          style: _loginRegStyles(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Transform(
                    transform: Matrix4.translationValues(
                        delayAnimation.value * width, 0.0, 0.0),
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.supervised_user_circle,
                                  color: Colors.blueGrey),
                              hintText: "Username",
                              labelText: "Tài khoản",
                            ),
                            // ignore: missing_return
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Vui lòng nhập tên tài khoản";
                              }
//                               return "";
                            },
                            onSaved: (val) {
                              _nameController.text = val;
                            },
                            autocorrect: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
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
//                               return "";
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
                            obscureText: hidePass,
                            decoration: InputDecoration(
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
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                hintText: "Password",
                                labelText: "Mật khẩu"),
                            // ignore: missing_return
                            validator: (val) {
                              if (val.length < 6) {
                                return "Mật khẩu ít nhất phải có 6 ký tự";
                              }
//                               return "";
                            },
                            onSaved: (val) {
                              _passwordController.text = val;
                            },
                            autocorrect: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: hidePass,
                            decoration: InputDecoration(
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
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                hintText: "Confirm Password",
                                labelText: "Xác nhận mật khẩu"),
                            // ignore: missing_return
                            validator: (val) {
                              if (val.length < 6) {
                                return "Mật khẩu ít nhất phải có 6 ký tự";
                              } else if (val.isEmpty) {
                                return "Mật khẩu không thể rỗng!";
                              } else if (_passwordController.text != val) {
                                return "Mật khẩu không trùng nhau!";
                              }
//                               return "";
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
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              minWidth: MediaQuery.of(context).size.width,
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    "Đăng ký".toUpperCase(),
                                    style: _btnStyle(),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                signUpUser();
                              },
                              color: Color(0xFFB33771),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoading ?? true,
                    child: Center(
                      child: CircularProgressIndicator(),
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

  Future signUpUser() async {
    print("signUp");
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      _showLoadingIndicator();
      FirebaseUser user = await firebaseAuth.currentUser();
      if (user == null) {
        authEmail
            .emailSignUp(_emailController.text, _passwordController.text)
            .then((user) {
          if (user == null) {
            _dismissLoadingIndicator();
          } else {
            formState.reset();
            // user.sendEmailVerification();
            // here user.uid triggers an id inside the user which should match id of the user document
            userManagement.createUser(user.uid.toString(), {
              'userId': user.uid,
              'username': _nameController.text.toString(),
              'email': _emailController.text,
            });

            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => Login()));
            // pushAndRemoveUtil makes users to not see the login screen when they press the back button
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    }
  }

  _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
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

  _dismissLoadingIndicator() {
    Navigator.pop(dialogContext);
  }
}
