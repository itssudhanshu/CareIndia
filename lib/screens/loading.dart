import 'package:CareIndia/services/livedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void nextRoute() async {
    LiveData instance = LiveData();
    await instance.getData();
    await instance.countryList();
    await instance.getCountryData();

    // await Future.delayed(Duration(seconds: 3))5;

    Navigator.pushReplacementNamed(context, '/navigation', arguments: {
      'countryData': instance.countryData,
      'allCountries': instance.allCountries,
      'countries': instance.allCountries,
      'world_cases': instance.worldCases,
      'world_deaths': instance.worldDeaths,
      'world_recovered': instance.worldRecovered,
      'world_todaycases': instance.worldTodaycases,
      'world_todaydeaths': instance.worldTodaydeaths,
      'statewise': instance.statewise,
      'casetimeseries': instance.casetimeseries,
    });
  }

  void initState() {
    super.initState();
    nextRoute();
    // Route route = MaterialPageRoute(builder: (context) => HomeScreen());
    //         Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: SpinKitFadingCube(
                color: Colors.white,
                size: 80.0,
                duration: Duration(seconds: 1),
              ),
            ),
            Positioned(
              bottom: 60,
              child: Row(
                children: <Widget>[
                  Text(
                    'Loading ',
                    style: TextStyle(
                      fontFamily: "GothamBook",
                      fontSize: 20,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  JumpingText(
                    '...',
                    style: TextStyle(
                      fontFamily: "GothamBook",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Positioned(
              bottom: 30,
              child: Text(
                'STAY HOME, STAY SAFE!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "GothamMedium_0",
                  fontSize: 13,
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
