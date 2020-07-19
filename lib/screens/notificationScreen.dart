import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:gasgasapp/model/products.dart';
import 'package:gasgasapp/ui/oder_details.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final FirebaseUser userID;

  NotificationScreen({
    this.userID,
  });

  @override
  _NotificationScreen createState() => _NotificationScreen(userID: userID);
}

class _NotificationScreen extends State<NotificationScreen> {
  final FirebaseUser userID;

  int countProduct;
  String address;
  String phone;
  double totalPrice;
  Timestamp timeBuy;
  bool flag;
  List<String> productId = List<String>();

  _NotificationScreen({this.userID});

  @override
  Widget build(BuildContext context) {
    StreamBuilder deliveredData = StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(userID.uid)
          .document("data")
          .collection('payment')
          .orderBy('numberId', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              if (document.data['status'] == 'delivered') {
                timeBuy = document.data['time'];
                String timeOrder = DateFormat.d().format(
                    DateTime.now().subtract(
                        Duration(seconds: timeBuy.seconds)));
                return Card(
                  elevation: 8.0,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                userID: userID,
                                numberId: document.data['numberId'],
                                orderId: document.data['orderId'],
                                status: document.data['status'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Text(
                            "#${document.data['numberId']}",
                          ),
                          title: Text("Đơn hàng ${document.data['numberId']}"),
                          subtitle: Text(
                              "Bạn đã sử dụng gas được $timeOrder ngày."),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OrderDetails(
                                    userID: userID,
                                    numberId: document.data['numberId'],
                                    orderId: document.data['orderId'],
                                    status: document.data['status'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                );
              } else {
                return Container();
              }
            }).toList(),
          );
        } else {
          return Container();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Thông báo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: deliveredData,
      ),
    );
  }

//  TextStyle _btnStyle() {
//    return TextStyle(
//      color: Colors.white,
//      fontWeight: FontWeight.bold,
//    );
//  }

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
}
