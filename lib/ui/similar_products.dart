import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimilarProducts extends StatefulWidget {
  final productID;

  SimilarProducts({this.productID});

  @override
  _SimilarProductsState createState() =>
      _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  FirebaseUser userID;
  bool liked1 = true;
  bool liked2 = true;
  bool liked3 = true;
  bool liked4 = true;
  bool liked5 = true;
  TextEditingController _controllerText = TextEditingController();
  String rateText;
  int rateStar;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.userID = user;
      });
    });
  }

  String userName() {
    if (userID != null) {
      if (userID.displayName == null) {
        return userID.email.replaceAll('@gmail.com', '');
      }
      return userID.displayName;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                IconButton(
                  color: liked1 ? Colors.yellowAccent : Colors.grey,
                  icon: liked1 ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      if (liked1) {
                        liked1 = !liked1;
                        liked2 = false;
                        liked3 = false;
                        liked4 = false;
                        liked5 = false;
                      } else {
                        liked1 = !liked1;
                      }
                    });
                  },
                ),
                Container(
                  width: 5.0,
                ),
                IconButton(
                  color: liked2 ? Colors.yellowAccent : Colors.grey,
                  icon: liked2 ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      if (liked2) {
                        liked2 = !liked2;
                        liked3 = false;
                        liked4 = false;
                        liked5 = false;
                      } else {
                        liked2 = !liked2;
                        liked1 = true;
                      }
                    });
                  },
                ),
                Container(
                  width: 5.0,
                ),
                IconButton(
                  color: liked3 ? Colors.yellowAccent : Colors.grey,
                  icon: liked3 ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      if (liked3) {
                        liked3 = !liked3;
                        liked4 = false;
                        liked5 = false;
                      } else {
                        liked3 = !liked3;
                        liked2 = true;
                        liked1 = true;
                      }
                    });
                  },
                ),
                Container(
                  width: 5.0,
                ),
                IconButton(
                  color: liked4 ? Colors.yellowAccent : Colors.grey,
                  icon: liked4 ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      if (liked4) {
                        liked4 = !liked4;
                        liked5 = false;
                      } else {
                        liked4 = !liked4;
                        liked3 = true;
                        liked2 = true;
                        liked1 = true;
                      }
                    });
                  },
                ),
                Container(
                  width: 5.0,
                ),
                IconButton(
                  color: liked5 ? Colors.yellowAccent : Colors.grey,
                  icon: liked5 ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      if (liked5) {
                        liked5 = !liked5;
                      } else {
                        liked5 = !liked5;
                        liked4 = true;
                        liked3 = true;
                        liked2 = true;
                        liked1 = true;
                      }
                    });
                  },
                ),
                Container(
                  width: 5.0,
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                minLines: 10,
                maxLines: 15,
                autocorrect: false,
                controller: _controllerText,
                decoration: InputDecoration(
                  hintText: 'Đánh giá sản phẩm của bạn về sản phẩm',
                  filled: true,
                  fillColor: Color(0xFFDBEDFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (text) {
                  rateText = text;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
            child: MaterialButton(
              textColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              child: Text("Gửi"),
              onPressed: () async {
                setState(() {
                  if (liked1 && liked2 && liked3 && liked4 && liked5)
                    rateStar = 5;
                  else if (liked1 && liked2 && liked3 && liked4)
                    rateStar = 4;
                  else if (liked1 && liked2 && liked3)
                    rateStar = 3;
                  else if (liked1 && liked2)
                    rateStar = 2;
                  else if (liked1)
                    rateStar = 1;
                  else
                    rateStar = 0;

                  Firestore.instance
                      .collection("allrate")
                      .add({
                    'id': widget.productID,
                    'star': rateStar,
                    'comment': rateText,
                    'username': "${userName()}",
                  });
                  Firestore.instance
                      .collection(userID.uid)
                      .document("rate")
                      .collection("isvoted")
                      .add({
                    'id': widget.productID,
                    'isvoted': true,
                  });
                });
                _controllerText.clear();
                Fluttertoast.showToast(
                  msg: "Cảm ơn sự đóng góp của bạn!",
                );
                liked5 = true;
                liked4 = true;
                liked3 = true;
                liked2 = true;
                liked1 = true;
              },
              color: Color(0xFFB33771),
            ),
          ),
        ],
      ),
    );
  }
}
