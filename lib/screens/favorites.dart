import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Favorites extends StatefulWidget {
  final FirebaseUser userID;

  Favorites({this.userID});

  @override
  _FavoritesState createState() => _FavoritesState(userID: userID);
}

class _FavoritesState extends State<Favorites> {
  bool liked = false;
  final FirebaseUser userID;

  _FavoritesState({this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Yêu thích"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(userID.uid)
              .document('data')
              .collection('favorites')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.asset(
                          "${document.data['image']}",
                        ),
                        title: Text("${document.data['name']}"),
                        subtitle: Text("₹ ${document.data['price']}"),
                        trailing: IconButton(
                          color: liked ? Colors.grey : Colors.red,
                          icon: liked
                              ? Icon(
                                  Icons.favorite_border,
                                )
                              : Icon(Icons.favorite),
                          onPressed: () async {
                            setState(() {
                              // liked = !liked;
                              Firestore.instance
                                  .collection(userID.uid)
                                  .document('data')
                                  .collection("favorites")
                                  .document(document.documentID)
                                  .delete();
                            });
                            Fluttertoast.showToast(
                                msg: "Removed From Favorites",
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
    );
  }
}
