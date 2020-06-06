import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            padding: EdgeInsets.only(top: 40),
            height: 100,
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
            child: Text(
              'ChatBot',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 2.0,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Coming Soon...',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Center(
              child: Container(
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            AdmobBanner(adUnitId: "ca-app-pub-8046768523927143/1789400955", adSize: AdmobBannerSize.LARGE_BANNER),
          ],
        ),
      ),
    );
  }
}
