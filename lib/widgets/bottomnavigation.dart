import 'package:CareIndia/pages/chatbot.dart';
import 'package:CareIndia/pages/contact.dart';
import 'package:CareIndia/pages/indiastate.dart';
import 'package:CareIndia/pages/news.dart';
import 'package:CareIndia/screens/home.dart';
import 'package:CareIndia/services/feeds.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// const String testDevice = 'e2KE6YaYrPhwb3l5MQed1Xrtcp92';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<dynamic> updatetime = [];
  int currentTab = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  IndiaStateWise ind;
  News news;
  ChatBot chatbot;
  Contact contact;
  HomeScreen home;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);

    ind = IndiaStateWise();
    news = News();
    chatbot = ChatBot();
    contact = Contact();
    home = HomeScreen();

    pages = [news, ind, home, chatbot, contact];
    currentPage = home;

    super.initState();
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  _showNotification() async {
    FeedLogs instance = FeedLogs();
    await instance.getFeeds();
    setState(() {
      updatetime = instance.updatetime;
    });

    var android = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        // color: const Color.fromARGB(255, 0, 3, 20),
        importance: Importance.Max,
        priority: Priority.High);
    var iOS = new IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Daily Feeds', updatetime[0]['update'], platform);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 80.0,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500].withOpacity(.3),
                offset: Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 0, 3, 20),
                Color.fromARGB(255, 25, 200, 219),
              ],
            ),
          ),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 2,
            height: 50.0,
            items: <Widget>[
              Icon(FontAwesome.feed, size: 25, color: Colors.black),
              Icon(Entypo.line_graph, size: 25, color: Colors.black),
              Icon(Ionicons.ios_stats, size: 25, color: Colors.black),
              Icon(MaterialIcons.chat, size: 25, color: Colors.black),
              Icon(AntDesign.contacts, size: 25, color: Colors.black),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              if (index == 2 || index == 3 || index == 4) {
                _showNotification();
              }
              // _nativeAd ??= createNativeAd();
              // _nativeAd
              //   ..load()
              //   ..show(
              //     anchorType:
              //         Platform.isAndroid ? AnchorType.bottom : AnchorType.top,
              //   );
              setState(() {
                currentTab = index;
                currentPage = pages[index];
              });
            },
          ),
        ),
      ),
      body: currentPage,
    );
  }
}
