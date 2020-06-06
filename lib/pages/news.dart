import 'package:CareIndia/constants.dart';
import 'package:CareIndia/services/feeds.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<dynamic> updatetime = [];
  GlobalKey<RefreshIndicatorState> refreshKey;
  Widget feeds;
  static var now = new DateTime.now();
  var today = DateFormat('d MMM').format(now);

  Future<List<dynamic>> getFeed() async {
    FeedLogs instance = FeedLogs();
    await instance.getFeeds();
    setState(() {
      updatetime = instance.updatetime;
      // print(updatetime[1]);
    });
    return updatetime;
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getFeed();
    return null;
  }


  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (updatetime.length > 0) {
      feeds = ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: updatetime.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 4),
                        blurRadius: 20,
                        color: kShadowColor,
                      ),
                    ],
                  ),
                  child: ListTile(
                    subtitle: Text(
                      updatetime[index]['time'],
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    title: Text(
                      updatetime[index]['update'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if(index % 4 == 0)  AdmobBanner(adUnitId: "ca-app-pub-8046768523927143/3275665020", adSize: AdmobBannerSize.BANNER),
              ]
            ),
          );
        },
      );
    } else {
      feeds = Center(
          child: Column(
        children: <Widget>[
          Text('TILL NOW NO FEEDS!!'),
          AdmobBanner(adUnitId: "ca-app-pub-8046768523927143/3275665020", adSize: AdmobBannerSize.LARGE_BANNER),
        ],
      ));
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            padding: EdgeInsets.only(top: 30),
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 0, 3, 20),
                  Color.fromARGB(255, 25, 200, 219),
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Daily Feeds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '[${today.toString()}]',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshList();
        },
        key: refreshKey,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                feeds,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyNewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
