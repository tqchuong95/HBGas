import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasgasapp/admin/orderDetailsAdmin.dart';
import 'package:provider/provider.dart';
import 'package:gasgasapp/blocs/themeChanger.dart';
import 'package:gasgasapp/screens/about.dart';
import 'package:gasgasapp/screens/contact.dart';
import 'package:gasgasapp/screens/favorites.dart';
import 'package:gasgasapp/screens/loginPage.dart';
import 'package:gasgasapp/screens/myAccount.dart';
import 'package:gasgasapp/screens/settings.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {
  bool darkmode = false;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(currentUser.uid)
              .document("data")
              .collection('payment')
              .orderBy('numberId', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsAdmin(
                                userID: currentUser,
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
                                  builder: (context) => OrderDetailsAdmin(
                                    userID: currentUser,
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
                }).toList(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(currentUser.uid)
              .document("data")
              .collection('payment')
              .orderBy('numberId', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
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
                                  builder: (context) => OrderDetailsAdmin(
                                    userID: currentUser,
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
        ),
      ),
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(currentUser.uid)
              .document("data")
              .collection('payment')
              .orderBy('numberId', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
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
                                  builder: (context) => OrderDetailsAdmin(
                                    userID: currentUser,
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
        ),
      ),
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(currentUser.uid)
              .document("data")
              .collection('payment')
              .orderBy('numberId', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  if (document.data['status'] == 'cancelled') {
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
                                  builder: (context) => OrderDetailsAdmin(
                                    userID: currentUser,
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
        ),
      ),
    ];
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.select_all,
              color: Color(0xFFB33771),
            ),
            title: Text(
              'Tất cả',
              style: TextStyle(color: Color(0xFFB33771)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_shipping,
              color: Color(0xFFB33771),
            ),
            title: Text(
              'Đang giao',
              style: TextStyle(color: Color(0xFFB33771)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done_outline,
              color: Color(0xFFB33771),
            ),
            title: Text(
              'Đã giao',
              style: TextStyle(color: Color(0xFFB33771)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Color(0xFFB33771),
            ),
            title: Text(
              'Đã giao',
              style: TextStyle(color: Color(0xFFB33771)),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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
