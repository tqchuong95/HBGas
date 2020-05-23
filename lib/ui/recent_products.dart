import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasgasapp/model/products.dart';
import 'package:gasgasapp/screens/product_detail.dart';

class RecentProducts extends StatefulWidget {
  final String dropdownValue;

  RecentProducts({this.dropdownValue});

  @override
  _RecentProductsState createState() =>
      _RecentProductsState(dropValue: dropdownValue);
}

class _RecentProductsState extends State<RecentProducts> {
  Products _products = Products();
  FirebaseUser userID;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String dropValue;

  _RecentProductsState({this.userID, this.dropValue});

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.userID = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int length;
    dropValue.toLowerCase() == 'all'
        ? length = _products.all.length
        : dropValue.toLowerCase() == 'bottle'
            ? length = _products.bottle.length
            : dropValue.toLowerCase() == 'stove'
                ? length = _products.stove.length
                : length = _products.accessories.length;
    return GridView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          child: Hero(
            tag: _products.getListProducts(dropValue)[i].productDetailsName,
            child: Material(
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      productID: _products.getListProducts(dropValue)[i].productID,
                      productDetailsName: _products.getListProducts(dropValue)[i].productDetailsName,
                      productDetailsImage: _products.getListProducts(dropValue)[i].productDetailsImage,
                      productDetailsoldPrice: _products.getListProducts(dropValue)[i].productDetailsoldPrice,
                      productDetailsPrice: _products.getListProducts(dropValue)[i].productDetailsPrice,
                      productDetailsDesc: _products.getListProducts(dropValue)[i].productDetailsDesc,
                      productDetailClassify: _products.getListProducts(dropValue)[i].productDetailClassify,
                      userID: userID,
                    ),
                  ),
                ),
                child: GridTile(
                  child: Image.asset(
                    _products.getListProducts(dropValue)[i].productDetailsImage,
                    fit: BoxFit.cover,
                  ),
                  footer: Container(
                    height: 30.0,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${_products.getListProducts(dropValue)[i].productDetailsName}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}
