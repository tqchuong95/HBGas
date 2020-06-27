import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/ui/similar_rate.dart';
import 'package:gasgasapp/ui/cart_product_details.dart';
import 'package:gasgasapp/ui/similar_products.dart';

class ProductDetails extends StatefulWidget {
  final productID;
  final productDetailsName;
  final productDetailsImage;
  final productDetailsoldPrice;
  final productDetailsPrice;
  final productDetailsDesc;
  final productDetailClassify;
  final FirebaseUser userID;

  ProductDetails(
      {this.productID,
      this.productDetailsName,
      this.productDetailsImage,
      this.productDetailsoldPrice,
      this.productDetailsPrice,
      this.productDetailsDesc,
      this.productDetailClassify,
      this.userID});

  @override
  _ProductDetailsState createState() => _ProductDetailsState(userID: userID);
}

class _ProductDetailsState extends State<ProductDetails> {
  bool liked = false;
  String id;
  FirebaseUser userID;
  int _currentIndex = 0;
  Future<bool> isRate;

  _ProductDetailsState({this.userID});

  Future<int> getData(FirebaseUser userID) async {
    int tmp;
    await Firestore.instance
        .collection(userID.uid)
        .document("data")
        .collection('cartItems')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      tmp = snapshot.documents.length;
    });
    return tmp;
  }

  Future<bool> isVote(FirebaseUser userID) async {
    bool _isRate = false;
    await Firestore.instance
        .collection(userID.uid)
        .document("rate")
        .collection('isvoted')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot != null) {
        snapshot.documents.forEach((f) {
          if (f.data['id'].compareTo(widget.productID) == 0)
            _isRate = f.data['isvoted'];
        });
      }
      print(_isRate);
    });
    return _isRate;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isRate = isVote(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Hoa Binh Gas"),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartProductDetails(
                        cartProductName: widget.productDetailsName,
                        cartProductImage: widget.productDetailsImage,
                        cartProductPrice: widget.productDetailsPrice,
                        userID: userID,
                      ),
                    ),
                  );
                },
              ),
              Container(
                child: FutureBuilder<int>(
                  future: getData(userID),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      if (snapshot.data >= 1) {
                        return Positioned(
                            top: 0,
                            right: 0,
                            child: new Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.green[800]),
                                Positioned(
                                    top: 4.0,
                                    right: 5.0,
                                    child: new Center(
                                      child: new Text(
                                        '${snapshot.data}',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ));
                      } else {
                        return Container();
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: Text(
                  "${widget.productDetailsName}",
                  style: TextStyle(
                      color: Color(0xFFB33771),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: IconButton(
                  color: liked ? Color(0xFFB33771) : Colors.grey,
                  icon: liked
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () async {
                    if (!liked) {
                      DocumentReference ref = await Firestore.instance
                          .collection(userID.uid)
                          .document("data")
                          .collection("favorites")
                          .add({
                        'name': widget.productDetailsName,
                        'image': widget.productDetailsImage,
                        'price': widget.productDetailsPrice,
                      });
                      setState(() {
                        liked = !liked;
                        id = ref.documentID;
                      });
                      print(ref.documentID);
                      Fluttertoast.showToast(
                          msg: "Item Added to Favorites",
                          toastLength: Toast.LENGTH_LONG);
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 300.0,
            child: Image.asset(
              widget.productDetailsImage,
            ),
          ),

          // ------------------- Price Details ------------------

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("Giá gốc :  "),
                Text(
                  " ${widget.productDetailsoldPrice} VND",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("Giá khuyến mãi :  "),
                Text(
                  " ${widget.productDetailsPrice} VND",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Row(
              children: <Widget>[
                Text("Tiết kiệm :  "),
                Text(
                  " ${widget.productDetailsoldPrice - widget.productDetailsPrice} VND",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          //  ---------------------- Add to Cart Buttons ------------

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
            child: MaterialButton(
              textColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              child: Text("Thêm vào giỏ hàng"),
              onPressed: () async {
                DocumentReference ref = await Firestore.instance
                    .collection(userID.uid)
                    .document("data")
                    .collection("cartItems")
                    .add({
                  'id': widget.productID,
                  'name': widget.productDetailsName,
                  'image': widget.productDetailsImage,
                  'price': widget.productDetailsPrice,
                });
                setState(() {
                  id = ref.documentID;
                  _currentIndex = _currentIndex + 1;
                });
                Fluttertoast.showToast(
                  msg: "Product Added to Cart",
                );
              },
              color: Color(0xFFB33771),
            ),
          ),

          // -------- About this Item ------------
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 20.0, bottom: 20.0),
            child: ListTile(
              title: Text(
                "Mô tả",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text("${widget.productDetailsDesc}"),
              ),
            ),
          ),
          Padding(
            child: Text(
              "Đánh giá",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
          ),
          Container(
            child: FutureBuilder<bool>(
              future: isRate,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return (!false)
                      ? Column(
                          children: <Widget>[
                            Container(
                              height: 400.0,
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SimilarProducts(
                                productID: widget.productID,
                              ),
                            ),
                            Text(
                              "Những đánh giá khác cho sản phẩm",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Container(
                              height: 400.0,
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SimilarRate(
                                productID: widget.productID,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 400.0,
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SimilarRate(
                            productID: widget.productID,
                          ),
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
