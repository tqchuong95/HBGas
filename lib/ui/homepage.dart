import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/screens/notificationScreen.dart';
import 'package:provider/provider.dart';
import 'package:gasgasapp/blocs/themeChanger.dart';
import 'package:gasgasapp/screens/about.dart';
import 'package:gasgasapp/screens/contact.dart';
import 'package:gasgasapp/screens/favorites.dart';
import 'package:gasgasapp/screens/loginPage.dart';
import 'package:gasgasapp/screens/myAccount.dart';
import 'package:gasgasapp/screens/settings.dart';
import 'package:gasgasapp/ui/cart_product_details.dart';
import 'package:gasgasapp/ui/recent_products.dart';
import 'package:gasgasapp/screens/oder_managerment.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool darkmode = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String dropdownValue = 'All';

  _HomePageState();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String userName() {
    if (currentUser != null) {
      if (currentUser.displayName == null) {
        return currentUser.email.replaceAll('@gmail.com', '');
      }
      return currentUser.displayName;
    } else {
      return "";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "No Email Address";
    }
  }

  String photoUrl() {
    if (currentUser != null) {
      return currentUser.email[0].toUpperCase();
    } else {
      return "A";
    }
  }

  Future<int> getData(FirebaseUser userID) async {
    int tmp = 0;
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

  Future<int> getNotification(FirebaseUser userID) async {
    int tmp = Timestamp.now().seconds;
    await Firestore.instance
        .collection(userID.uid)
        .document("data")
        .collection('payment')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['flag'] == true) {
          Timestamp timestamp = f.data['time'];
          tmp = timestamp.seconds;
        }
      });
    });
    return tmp;
  }

  Future<String> loadAllProduct(String valueAll) async {
    await Future.delayed(Duration(seconds: 1));
    return Future.value(valueAll);
  }

  @override
  Widget build(BuildContext context) {
    // Which is used to listen to the nearest change and provides the current state and rebuilds the widget.
    ThemeChanger theme = Provider.of<ThemeChanger>(context);

    Future<Login> _signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(
          msg: "Đăng xuất thành công.",
          toastLength: Toast.LENGTH_LONG,
        );
        return new Login();
      } catch (e) {
        print(e);
        return null;
      }
    }

    return Scaffold(
      // Drawer Start
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFB33771),
              ),
              accountName: Text("${userName()}"),
              accountEmail: Text("${email()}"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text("${photoUrl()}",
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            ListTile(
              leading: darkmode
                  ? Image.asset(
                      'images/moon.png',
                      height: 30.0,
                      width: 26.0,
                    )
                  : Image.asset(
                      'images/sunny.png',
                      height: 30.0,
                      width: 26.0,
                    ),
              title: Text("DarkMode"),
              trailing: Switch(
                value: darkmode,
                onChanged: (val) {
                  setState(() {
                    darkmode = val;
                  });
                  if (darkmode) {
                    theme.setTheme(ThemeData.dark());
                  } else {
                    theme.setTheme(ThemeData.light());
                  }
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                          userID: currentUser,
                        )));
              },
              child: _showList(
                "Thông báo",
                (Icons.notifications),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyAccount()));
              },
              child: _showList(
                "Tài khoản của tôi",
                (Icons.account_box),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderManagement(
                      userID: currentUser,
                    ),
                  ),
                );
              },
              child: _showList(
                "Quản lý đơn hàng",
                (Icons.storage),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Favorites(
                      userID: currentUser,
                    ),
                  ),
                );
              },
              child: _showList(
                "Yêu thích",
                (Icons.favorite),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Settings()));
              },
              child: _showList(
                "Cài đặt",
                (Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => About()));
              },
              child: _showList(
                "Giới thiệu",
                (Icons.adjust),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Contact()));
              },
              child: _showList(
                "Liên hệ",
                (Icons.contact_phone),
              ),
            ),
            InkWell(
              onTap: () {
                _signOut().then((value) {
                  if (value == null) {
                    Fluttertoast.showToast(
                      msg: "Đăng xuất không thành công.",
                      toastLength: Toast.LENGTH_LONG,
                    );
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => value));
                  }
                });
              },
              child: _showList(
                "Đăng xuất",
                (Icons.exit_to_app),
              ),
            ),
          ],
        ),
      ),
      // Drawer ends
      appBar: AppBar(
        titleSpacing: 2.0,
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Hoa Binh Gas"),
        // Showing Cart Icon
        actions: <Widget>[
          Stack(children: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                          userID: currentUser,
                        )));
              },
            ),
            Container(
              child: FutureBuilder<int>(
                future: getNotification(currentUser),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    if (DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data * 1000)
                            .add(new Duration(days: 40))
                            .compareTo(DateTime.now()) <
                        0) {
                      return Positioned(
                        top: 7.0,
                        right: 8.0,
                        child: Icon(Icons.brightness_1,
                            size: 12.0, color: Colors.green[800]),
                      );
                    } else
                      return Container();
                  }
                },
              ),
            ),
          ]),
          Stack(children: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CartProductDetails(
                          userID: currentUser,
                        )));
              },
            ),
            Container(
              child: FutureBuilder<int>(
                future: getData(currentUser),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    if (snapshot.data > 0) {
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
                    } else
                      return Container();
                  }
                },
              ),
            ),
          ])
        ],
        // Showing Search Bar
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       showSearch(context: context, delegate: ProductSearch());
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: <Widget>[
          _imgCarousel(),
          Row(children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sản phẩm hiện tại",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.6,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10.0),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.keyboard_arrow_right),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Color(0xFFB33771), fontSize: 16.0),
                underline: Container(
                  height: 2,
                  color: Color(0xFFB33771),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['All', 'Bottle', 'Stove', 'Accessories']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: value.toLowerCase() == 'all'
                        ? Text("Tất cả")
                        : value.toLowerCase() == 'bottle'
                            ? Text("Bình gas")
                            : value.toLowerCase() == 'stove'
                                ? Text("Bếp gas")
                                : Text("Phụ kiện"),
                  );
                }).toList(),
              ),
            ),
          ]),
          //grid view
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
//              child: RecentProducts(dropdownValue: dropdownValue),
              child: FutureBuilder<String>(
                future: loadAllProduct(dropdownValue),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    return RecentProducts(dropdownValue: dropdownValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgCarousel() {
    return Container(
      height: 200.0,
      child: Carousel(
        overlayShadow: true,
        overlayShadowColors: Colors.black45,
        dotSize: 5.0,
        autoplay: true,
        animationCurve: Curves.bounceInOut,
        dotBgColor: Colors.transparent,
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/c1.jpg'),
          AssetImage('images/c5.jpg'),
          AssetImage('images/c2.jpg'),
          AssetImage('images/c3.jpg'),
          AssetImage('images/c4.jpg'),
        ],
      ),
    );
  }

  Widget _showList(String s, IconData i) {
    return ListTile(
      leading: Icon(
        i,
        color: Colors.yellow[700],
      ),
      title: Text(s),
    );
  }
}
