import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/ui/homepage.dart';

// ignore: must_be_immutable
class ConfirmOrderPage extends StatelessWidget {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final double totalPrice;
  final double delivery = 0;
  String payment = 'cash';
  final databaseReference = Firestore.instance;
  final FirebaseUser userID;

  ConfirmOrderPage({this.userID, this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Xác nhận thanh toán"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Thanh toán:"),
              Text("$totalPrice VND"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Phí vận chuyển:"),
              Text("$delivery VND"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tổng tiền: ",
                style: Theme.of(context).textTheme.title,
              ),
              Text("${totalPrice + delivery} VND",
                  style: Theme.of(context).textTheme.title),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Địa chỉ giao hàng".toUpperCase())),
          Column(
            children: <Widget>[
              TextFormField(
                autovalidate: true,
                controller: _addressController,
                autocorrect: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add_location),
                  hintText: "Vui lòng nhập địa chỉ",
                  labelText: "Địa chỉ *",
                ),
                // ignore: missing_return
                validator: (val) {
                  if (val.isEmpty) {
                    return "Vui lòng cung cấp địa chỉ.";
                  }
                },
                onSaved: (val) {
                  _addressController.text = val;
                },
              ),
              Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Text("Liên hệ:".toUpperCase())),
              TextFormField(
                autovalidate: true,
                controller: _phoneController,
                autocorrect: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Vui lòng nhập số điện thoại",
                  labelText: "Điện thoại *",
                ),
                // ignore: missing_return
                validator: (val) {
                  if (val.isEmpty) {
                    return "Vui lòng cung cấp số điện thoại.";
                  }
                },
                onSaved: (val) {
                  _phoneController.text = val;
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text("Phương thức thanh toán".toUpperCase())),
          RadioListTile<String>(
            title: const Text('Thanh toán khi nhận hàng'),
            value: 'cash',
            groupValue: payment,
            onChanged: (value) {
              payment = value;
            },
          ),
//          RadioListTile<String>(
//            title: const Text('Thanh toán online'),
//            value: 'online',
//            groupValue: payment,
//            onChanged: (value) {
//              payment = value;
//            },
//          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              color: Color(0xFFB33771),
              onPressed: () {
                if (_addressController.text != "" && _phoneController.text != "") {
                  createRecord();
                  Fluttertoast.showToast(msg: 'Bạn đã đặt hàng thành công.');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  Fluttertoast.showToast(
                      msg: 'Vui lòng nhập đầy đủ thông tin.');
                }
              },
              child: Text(
                "Thanh toán",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void createRecord() async {
    await databaseReference
        .collection(userID.uid)
        .document("data")
        .collection("payment")
        .add({
      'address': _addressController.text,
      'phone': _phoneController.text,
      'total': totalPrice,
    });

    await databaseReference
        .collection(userID.uid)
        .document("data")
        .collection("cartItems")
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }
}
