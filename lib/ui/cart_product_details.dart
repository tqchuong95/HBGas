import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/ui/payment_product.dart';

class CartProductDetails extends StatefulWidget {
  final cartProductName;
  final cartProductImage;
  final cartProductPrice;
  final FirebaseUser userID;

  CartProductDetails({
    this.cartProductName,
    this.cartProductImage,
    this.cartProductPrice,
    this.userID,
  });

  @override
  _CartProductDetailsState createState() =>
      _CartProductDetailsState(userID: userID);
}

class _CartProductDetailsState extends State<CartProductDetails> {
  _CartProductDetailsState({this.userID});

  int countProduct;
  final FirebaseUser userID;
  double totalPrice;

  Future<String> getData() async {
    double total = 0;
    await Firestore.instance
        .collection(userID.uid)
        .document("data")
        .collection('cartItems')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      countProduct = snapshot.documents.length;
      snapshot.documents.forEach((f) => total += f.data['price']);
    });
    return Future.value(total.toString());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Giỏ hàng"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: height / 1.4,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(userID.uid)
                    .document("data")
                    .collection('cartItems')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Card(
                          elevation: 8.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset(
                                "${document.data['image']}",
                              ),
                              title: Text("${document.data['name']}"),
                              subtitle: Text("${document.data['price']} VND"),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    Firestore.instance
                                        .collection(userID.uid)
                                        .document("data")
                                        .collection("cartItems")
                                        .document(document.documentID)
                                        .delete();
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Sản phẩm đã được xóa!",
                                      toastLength: Toast.LENGTH_LONG);
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: width / 2.3,
                    child: Text(
                      "Tổng đơn hàng: ",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: width / 2.5,
                    child: FutureBuilder<String>(
                      future: getData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '0 VND',
                            textAlign: TextAlign.end,
                          );
                        } else {
                          if (snapshot.hasError)
                            return Text(
                              'Error',
                              textAlign: TextAlign.end,
                            );
                          else {
                            totalPrice = double.parse(snapshot.data);
                            return Text(
                              '${snapshot.data} VND',
                              textAlign: TextAlign.end,
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 12.0, bottom: 20.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                color: Color(0xFFB33771),
                minWidth: MediaQuery.of(context).size.width,
                textColor: Colors.white,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Tiến hành thanh toán",
                  style: _btnStyle(),
                ),
                onPressed: () {
                  if (totalPrice > 0.0)
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ConfirmOrderPage(
                              userID: userID,
                              totalPrice: totalPrice,
                            )));
                  else
                    Fluttertoast.showToast(msg: 'Không có sản phẩm.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }
}
