import 'package:CareIndia/constants.dart';
import 'package:CareIndia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthService _auth = AuthService();
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Widget skip_button = Text(
    'Skip',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      fontSize: 20.0,
    ),
  );

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color.fromARGB(255, 25, 200, 219) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () async {
                      dynamic result = await _auth.signInAnon();
                      Navigator.of(context).pushReplacementNamed('/loading');
                      if (result == null) {
                        print('error signing in');
                      } else {
                        print('signed in');
                        print(result.uid);
                      }
                    },
                    child: skip_button,
                  ),
                ),
                Container(
                  height: 480.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                        if (page == 2) {
                          skip_button = Text('');
                        }
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage('assets/images/3625506.png'),
                                height: 225.0,
                                width: 225.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Stay Home, Save Lives',
                              style: kTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25.0),
                            Text(
                              'Help stop coronavirus',
                              style: kSubtitleStyle.copyWith(
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/3636940.png',
                                ),
                                height: 225.0,
                                width: 225.0,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Thanks to Corona Warriors',
                              style: kTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              "In today's time doctors, police and other medical staff are the real heroes of our country. You are working hard to keep your country and society safe.",
                               style: kSubtitleStyle.copyWith(
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/icons/protection.png',
                                ),
                                height: 200.0,
                                width: 200.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'CareIndia',
                              style: kTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'This Application provides Realtime tracking with visual graphical implementation and live feeds specifically for India.',
                              textAlign: TextAlign.center,
                               style: kSubtitleStyle.copyWith(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              height: 50.0,
                              width: 110.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  // color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 8),
                                      blurRadius: 26,
                                      color: kShadowColor,
                                    ),
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black87,
                                    size: 25.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Material(
              elevation: 50.0,
              child: Container(
                // margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                height: 50.0,
                width: double.infinity,
                // alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500].withOpacity(.3),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async {
                    dynamic result = await _auth.signInAnon();
                    Navigator.of(context).pushReplacementNamed('/loading');
                    if (result == null) {
                      print('error signing in');
                    } else {
                      print('signed in');
                      print(result.uid);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
