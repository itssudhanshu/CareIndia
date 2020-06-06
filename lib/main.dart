import 'package:CareIndia/constants.dart';
import 'package:CareIndia/pages/about.dart';
import 'package:CareIndia/pages/case_details.dart';
import 'package:CareIndia/pages/feedback.dart';
import 'package:CareIndia/pages/indiastate.dart';
import 'package:CareIndia/screens/home.dart';
import 'package:CareIndia/screens/info.dart';
import 'package:CareIndia/screens/loading.dart';
import 'package:CareIndia/screens/welcome.dart';
import 'package:CareIndia/widgets/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize("ca-app-pub-8046768523927143~3102482620");

  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9ZmFoZHxhfGFjYWNzYmliYGlhYnMSHmg+JSMgJjc7Mj0gOyYTND4yOj99MDw+");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareIndia',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: "Poppins",
        textTheme: TextTheme(
          body1: TextStyle(
            color: kBodyTextColor,
          ),
        ),
      ),
      home: new SharedPref(),
      routes: {
        '/navigation': (context) => BottomNavigation(),
        '/home': (context) => HomeScreen(),
        '/info': (context) => InfoScreen(),
        '/loading': (context) => Loading(),
        '/cases': (context) => CaseDetails(),
        '/indiastate': (context) => IndiaStateWise(),
        '/welcome': (context) => WelcomePage(),
        '/feedback': (context) => FeedbackForm(),
        '/about': (context) => AboutUs(),
      },
    );
  }
}

class SharedPref extends StatefulWidget {
  @override
  _SharedPrefState createState() => _SharedPrefState();
}

class _SharedPrefState extends State<SharedPref> {
  SharedPreferences preferences;

  showWelcome() async {
    preferences = await SharedPreferences.getInstance();
    bool showcaseVisibilityStatus = preferences.getBool("welcome");

    if (showcaseVisibilityStatus == null) {
      preferences.setBool("welcome", false).then((bool success) {
        if (success)
          print("Successfull in writing showshoexase");
        else
          print("some bloody problem occured");
      });

      return true;
    }

    return false;
  }

  @override
  void initState() {
    showWelcome().then((status) {
      if (status) {
        print("first time");
        Navigator.of(context).pushReplacementNamed('/welcome');
      } else {
        print('not the first time');
        Navigator.of(context).pushReplacementNamed('/loading');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 0.0, height: 0.0);
  }
}
