import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasgasapp/ui/oder_details.dart';

class OrderManagement extends StatefulWidget {
  final FirebaseUser userID;

  OrderManagement({
    this.userID,
  });

  @override
  _OrderManagement createState() => _OrderManagement(userID: userID);
}

class _OrderManagement extends State<OrderManagement> {
  _OrderManagement({this.userID});

  int countProduct;
  final FirebaseUser userID;
  double totalPrice;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    StreamBuilder allOrder = StreamBuilder<QuerySnapshot>(
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
              return Card(
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text(
                      "#${document.data['numberId']}",
                    ),
                    title: Text("Đơn hàng ${document.data['numberId']}"),
                    subtitle: Text("${document.data['total']} VND"),
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
                ),
              );
            }).toList(),
          );
        } else {
          return Container();
        }
      },
    );
    StreamBuilder delivery = StreamBuilder<QuerySnapshot>(
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
              if (document.data['status'] == 'delivery') {
                return Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text(
                        "#${document.data['numberId']}",
                      ),
                      title: Text("Đơn hàng ${document.data['numberId']}"),
                      subtitle: Text("${document.data['total']} VND"),
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
                  ),
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
    StreamBuilder delivered = StreamBuilder<QuerySnapshot>(
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
                return Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text(
                        "#${document.data['numberId']}",
                      ),
                      title: Text("Đơn hàng ${document.data['numberId']}"),
                      subtitle: Text("${document.data['total']} VND"),
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
                  ),
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
    StreamBuilder cancelled = StreamBuilder<QuerySnapshot>(
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
              if (document.data['status'] == 'cancelled') {
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
                        subtitle: Text("${document.data['total']} VND"),
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
                    ),
                  ),
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Tất cả"),
              Tab(text: "Đang giao"),
              Tab(text: "Đã giao"),
              Tab(text: "Đã hủy"),
            ],
          ),
          title: Text('Đơn hàng'),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  height: height / 1.4,
                  child: allOrder,
                )
              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                  height: height / 1.4,
                  child: delivery,
                )
              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                  height: height / 1.4,
                  child: delivered,
                )
              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                  height: height / 1.4,
                  child: cancelled,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
