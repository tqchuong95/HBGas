import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimilarRate extends StatefulWidget {
  final productID;

  SimilarRate({this.productID});

  @override
  _SimilarRate createState() => _SimilarRate();
}

class _SimilarRate extends State<SimilarRate> {
  List<int> star = List<int>();
  List<String> user = List<String>();
  List<String> comment = List<String>();
  int count;

  Future<int> getLengthRate() async {
    int _count = 0;
    await Firestore.instance
        .collection("allrate")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['id'] == widget.productID) {
          _count++;
        }
      });
    });
    return _count;
  }

  Future<bool> getDataRate() async {
    bool tmp = false;

    await Firestore.instance
        .collection("allrate")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['id'] == widget.productID) {
          star.add(f.data['star']);
          user.add(f.data['username']);
          comment.add(f.data['comment']);
        }
      });
    });
    print(star);
    print(count);
    if (star != null && user != null && comment != null) tmp = true;

    return tmp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLengthRate().then((result) {
      setState(() {
        count = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ListView listRate = ListView.builder(
      itemCount: (count != null ? (count < 5 ? count : 4) : 0),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (index < (count != null ? (count < 4 ? count : 3) : 0))
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: FutureBuilder<bool>(
                          future: getDataRate(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else {
                              if (!snapshot.hasData)
                                return new Text('Loading...');
                              if (snapshot.data) {
                                return Column(
                                  // align the text to the left instead of centered
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      user[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          star[index] > 0
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: star[index] > 0
                                              ? Colors.yellowAccent
                                              : Colors.grey,
                                          size: 30.0,
                                        ),
                                        Icon(
                                          star[index] > 1
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: star[index] > 1
                                              ? Colors.yellowAccent
                                              : Colors.grey,
                                          size: 30.0,
                                        ),
                                        Icon(
                                          star[index] > 2
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: star[index] > 2
                                              ? Colors.yellowAccent
                                              : Colors.grey,
                                          size: 30.0,
                                        ),
                                        Icon(
                                          star[index] > 3
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: star[index] > 3
                                              ? Colors.yellowAccent
                                              : Colors.grey,
                                          size: 30.0,
                                        ),
                                        Icon(
                                          star[index] > 4
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: star[index] > 4
                                              ? Colors.yellowAccent
                                              : Colors.grey,
                                          size: 30.0,
                                        ),
                                      ],
                                    ),
                                    Text(comment[index]),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: RaisedButton(
                    onPressed: () {},
                    child: const Text('Tất cả đánh giá',
                        style: TextStyle(fontSize: 20)),
                  )),
          ),
        );
      },
    );
    AlertDialog alertDialog = AlertDialog(
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
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: count != null ? listRate : alertDialog,
          ),
        ],
      ),
    );
  }
}
