import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/admin/manageOrderCustomer.dart';
import 'package:provider/provider.dart';
import 'package:gasgasapp/blocs/themeChanger.dart';
import 'package:gasgasapp/screens/about.dart';
import 'package:gasgasapp/screens/contact.dart';
import 'package:gasgasapp/screens/favorites.dart';
import 'package:gasgasapp/screens/loginPage.dart';
import 'package:gasgasapp/screens/myAccount.dart';
import 'package:gasgasapp/screens/settings.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gasgasapp/admin/chartProduct.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  bool darkmode = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String dropdownValue = 'All';

  final List<SubscriberSeries> data = [
    SubscriberSeries(
      year: "2008",
      subscribers: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2009",
      subscribers: 11000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2010",
      subscribers: 12000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2011",
      subscribers: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2012",
      subscribers: 8500000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2013",
      subscribers: 7700000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2014",
      subscribers: 7600000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "2015",
      subscribers: 5500000,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
  ];

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

    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (SubscriberSeries series, _) => series.year,
          measureFn: (SubscriberSeries series, _) => series.subscribers,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyAccount()));
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settings()));
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
//         Showing Search Bar
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
//               showSearch(context: context, delegate: ProductSearch());
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: SubscriberChart(
                data: data,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              minWidth: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Center(
                  child: Text(
                    "Quản lý đơn hàng của khách hàng",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminOrderManagement(
                      userID: currentUser,
                    ),
                  ),
                );
//                Fluttertoast.showToast(
//                    msg: "Quản lý đơn hàng của khách hàng",
//                    toastLength: Toast.LENGTH_LONG);
              },
              color: Color(0xFFB33771),
            ),
            SizedBox(
              height: 10.0,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              minWidth: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Center(
                  child: Text(
                    "Quản lý khách hàng",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "Quản lý khách hàng", toastLength: Toast.LENGTH_LONG);
              },
              color: Color(0xFFB33771),
            ),
          ],
        ));
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
