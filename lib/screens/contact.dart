import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Liên hệ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Nếu quý khách hàng có những thắc mắc, ý kiến đóng góp hoặc cần biết thêm thông tin, vui lòng liên hệ với chúng tôi:",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Text(
              "-   Các cửa hàng trong hệ thống, làm việc từ 5h00 đến 22h00  tất cả các ngày trong tuần, kể cả ngày Lễ, Tết",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              "-   Tổng đài chăm sóc khách hàng 1900.5454.79, làm việc từ 5h00 đến 22h00 tất cả các ngày trong tuần",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              "-   Văn phòng công ty:P.805, lầu 8, TN Saigon Paragon, Số 3 Nguyễn Lương Bằng, P.Tân Phú, Quận 7, Tp.HCM",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              "Điện thoại: (08) 54136338   . Fax: (08) 54136340",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 50.0),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      _launchTwitter();
//                    },
//                    child: ListTile(
//                      title: Image.asset(
//                        'images/logos/twitter.png',
//                        height: 70.0,
//                        width: 70.0,
//                      ),
//                      subtitle: Center(
//                        child: Text(
//                          "Twitter",
//                          style: TextStyle(
//                            fontWeight: FontWeight.w400,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      _launchgithub();
//                    },
//                    child: ListTile(
//                      title: Image.asset(
//                        'images/logos/github.png',
//                        height: 70.0,
//                        width: 70.0,
//                      ),
//                      subtitle: Center(
//                        child: Text(
//                          "Github",
//                          style: TextStyle(
//                            fontWeight: FontWeight.w400,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: () {
//                      _launchlinkedIn();
//                    },
//                    child: ListTile(
//                      title: Image.asset(
//                        'images/logos/linkedin.png',
//                        height: 70.0,
//                        width: 70.0,
//                      ),
//                      subtitle: Center(
//                        child: Text(
//                          "LinkedIn",
//                          style: TextStyle(
//                            fontWeight: FontWeight.w400,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            SizedBox(
//              height: 10.0,
//            ),
//            Container(
//              child: Column(
//                children: <Widget>[
//                  Text("OR Email me at :"),
//                  Text("ramubugudi4@gmail.com",
//                      style: TextStyle(color: Colors.blueGrey))
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
  }
//
//  void _launchTwitter() async {
//    const url = 'https://twitter.com/_iamramu';
//    if (await canLaunch(Uri.encodeFull(url))) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
//
//  void _launchgithub() async {
//    const url = 'https://github.com/bugudiramu';
//    if (await canLaunch(Uri.encodeFull(url))) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
//
//  void _launchlinkedIn() async {
//    const url = 'https://www.linkedin.com/in/bugudi-ramu-2a5a5a161/';
//    if (await canLaunch(Uri.encodeFull(url))) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
}
