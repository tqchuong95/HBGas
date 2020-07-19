import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasgasapp/model/products.dart';
import 'package:gasgasapp/screens/oder_managerment.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final FirebaseUser userID;
  final int numberId;
  final int orderId;
  final String status;

  OrderDetails({
    this.userID,
    this.numberId,
    this.orderId,
    this.status,
  });

  @override
  _OrderDetails createState() => _OrderDetails(
      userID: userID, numberId: numberId, orderId: orderId, status: status);
}

class _OrderDetails extends State<OrderDetails> {
  int countProduct;
  final FirebaseUser userID;
  final int numberId;
  final int orderId;
  final String status;
  String address;
  String phone;
  double totalPrice;
  DateTime timeBuy;
  List<String> productId = List<String>();
  Products _products = Products();
  DocumentSnapshot _currentDocument;
  DocumentSnapshot _currentDocumentAdmin;

  _OrderDetails({this.userID, this.numberId, this.orderId, this.status});

  Future<String> getData() async {
    await Firestore.instance
        .collection(userID.uid)
        .document("data")
        .collection('payment')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['numberId'] == numberId) {
          address = f.data['address'];
          phone = f.data['phone'];
          totalPrice = f.data['total'];
          Timestamp timeSp = f.data['time'];
          int dateSp = timeSp.seconds;
          timeBuy = DateTime.fromMillisecondsSinceEpoch(dateSp * 1000);
          _currentDocument = f;
        }
      });
    });

    await Firestore.instance
        .collection("jjXdZHw6PDTYOAKvv7UZLt7LMcf2")
        .document("data")
        .collection('payment')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['numberId'] == numberId) {
          _currentDocumentAdmin = f;
        }
      });
    });

    await Firestore.instance
        .collection(userID.uid)
        .document("data")
        .collection('payment')
        .document("product")
        .collection('details')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['orderId'] == orderId) {
          productId.add(f.data['product']);
        }
      });
    });
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Thông tin chi tiết"),
      ),
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: FutureBuilder<String>(
                  future: getData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: productId.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Center(
                                    child: productCard(
                                        _products, productId[index])),
                              );
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.yellow[700],
                          ),
                          title: Text(
                            'Địa chỉ giao hàng: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text("$address"),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.yellow[700],
                          ),
                          title: Text(
                            'Điện thoại: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text("$phone"),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.yellow[700],
                          ),
                          title: Text(
                            'Thời gian mua: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                "${DateFormat("yyyy-MM-dd hh:mm:ss").format(timeBuy)}"),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: width / 2.5,
                                child: Text(
                                  '$totalPrice VND',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[Text("Error: ${snapshot.error}")];
                    } else {
                      children = <Widget>[Text("Awaiting result...")];
                    }
                    return Column(
                      children: children,
                    );
                  },
                ),
              ),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 12.0, bottom: 20.0),
                  child: (status == 'delivery')
                      ? MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          color: Color(0xFFB33771),
                          minWidth: MediaQuery.of(context).size.width,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Đã nhận/Hủy đơn hàng",
                            style: _btnStyle(),
                          ),
                          onPressed: () async {
                            _showDialogProduct();
                          },
                        )
                      : (status == 'delivered')
                          ? MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              color: Color(0xFFA9A9A9),
                              minWidth: MediaQuery.of(context).size.width,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Giao hàng thành công",
                                style: _btnStyle(),
                              ),
                              onPressed: () {},
                            )
                          : MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              color: Color(0xFFA9A9A9),
                              minWidth: MediaQuery.of(context).size.width,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Đơn hàng đã hủy",
                                style: _btnStyle(),
                              ),
                              onPressed: () {},
                            )),
            ],
          )),
    );
  }

  TextStyle _btnStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  Card productCard(Products product, String productId) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.asset(
            product.getProduct(productId).productDetailsImage,
          ),
          title: Text("${product.getProduct(productId).productDetailsName}"),
          subtitle:
              Text("${product.getProduct(productId).productDetailsPrice} VND"),
        ),
      ),
    );
  }

  void _showDialogProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Xác nhận đơn hàng"),
          content: new Text("Bạn đã nhận được hàng?/Bạn muốn hủy đơn hàng?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Đã nhận"),
              onPressed: () {
                setState(() {
                  Firestore.instance
                      .collection(userID.uid)
                      .document("data")
                      .collection("payment")
                      .document(_currentDocument.documentID)
                      .updateData({
                    'status': 'delivered',
                    'time': DateTime.now(),
                    'flag': true,
                  });
                  Firestore.instance
                      .collection("jjXdZHw6PDTYOAKvv7UZLt7LMcf2")
                      .document("data")
                      .collection("payment")
                      .document(_currentDocumentAdmin.documentID)
                      .updateData({
                    'status': 'delivered',
                    'time': DateTime.now(),
                    'flag': true,
                  });
                });
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderManagement(
                      userID: userID,
                    ),
                  ),
                );
              },
            ),
            FlatButton(
              child: new Text("Hủy đơn hàng"),
              onPressed: () {
                setState(() {
                  Firestore.instance
                      .collection(userID.uid)
                      .document("data")
                      .collection("payment")
                      .document(_currentDocument.documentID)
                      .updateData({
                    'status': 'cancelled',
                  });
                  Firestore.instance
                      .collection("jjXdZHw6PDTYOAKvv7UZLt7LMcf2")
                      .document("data")
                      .collection("payment")
                      .document(_currentDocumentAdmin.documentID)
                      .updateData({
                    'status': 'cancelled',
                  });
                });
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderManagement(
                      userID: userID,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
