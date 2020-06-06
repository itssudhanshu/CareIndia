import 'dart:ui';
import 'package:CareIndia/constants.dart';
import 'package:CareIndia/services/livedata.dart';
import 'package:CareIndia/widgets/counter.dart';
import 'package:CareIndia/widgets/myHeader.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map data = {};
  var now = new DateTime.now();
  GlobalKey<RefreshIndicatorState> refreshKey;
  List<String> countries = [];
  List<dynamic> countryData = [];
  int infected;
  int recovered;
  int death;
  int active;
  int todaycases;
  int tests;
  int todaydeaths;
  int casesPerOneMillion;
  int deathsPerOneMillion;
  int testsPerOneMillion;
  int worldCases;
  int worldDeaths;
  int worldRecovered;
  int worldTodaycases;
  int worldTodaydeaths;
  String url;
  String country;
  List<dynamic> statewise = [];
  List<dynamic> casetimeseries = [];
  String newAppUrl;
  String newerVersion;

  Future<void> getCountryData(String countryy) async {
    countryData.forEach((element) {
      if (element['country'] == countryy) {
        setState(() {
          country = element['country'];
          infected = element['cases'];
          recovered = element['recovered'];
          death = element['deaths'];
          active = element['active'];
          todaycases = element['todayCases'];
          tests = element['tests'];
          todaydeaths = element['todayDeaths'];
          casesPerOneMillion = element['casesPerOneMillion'];
          deathsPerOneMillion = element['deathsPerOneMillion'];
          testsPerOneMillion = element['testsPerOneMillion'];
          url = element['countryInfo']['flag'];
        });
      }
    });
  }

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
  );

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-8046768523927143/6543034185",
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event: $event");
        });
  }

  @override
  void initState() {
    infected == null ? getCountryData('India') : getCountryData(country);
    refreshKey = GlobalKey<RefreshIndicatorState>();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8046768523927143~3102482620");
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      newerVersion = remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      newAppUrl = remoteConfig.getString('updateUrl');
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      } else {
        print("App is Updated!");
        print(newAppUrl);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return new CupertinoAlertDialog(
          insetAnimationCurve: Curves.easeInOut,
          insetAnimationDuration: Duration(seconds: 5),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 0, 3, 20),
                    Color.fromARGB(255, 25, 200, 219),
                  ],
                ),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: FlatButton(
                splashColor: Color.fromARGB(255, 0, 3, 20),
                child: Text(
                  btnLabel,
                  style: kHeadingTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  print(statuses[Permission.storage]);
                  Navigator.pop(context);
                  try {
                    OtaUpdate()
                        .execute(newAppUrl,
                            destinationFilename: 'CareIndia_v'+newerVersion+'_Light.apk')
                        .listen(
                      (OtaEvent event) {
                        print('EVENT: ${event.status} : ${event.value}');
                      },
                    );
                  } catch (e) {
                    print('Failed to make OTA update. Details: $e');
                  }
                },
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: FlatButton(
                splashColor: Color.fromARGB(255, 25, 200, 219),
                child: Text(
                  btnLabelCancel,
                  style: kHeadingTextStyle.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void getRefreshedData() async {
    now = new DateTime.now();
    LiveData instance = LiveData();
    await instance.getData();
    await instance.getCountryData();

    setState(() {
      countryData = instance.countryData;
      countries = instance.allCountries;
      worldCases = instance.worldCases;
      worldDeaths = instance.worldDeaths;
      worldRecovered = instance.worldRecovered;
      worldTodaycases = instance.worldTodaycases;
      worldTodaydeaths = instance.worldTodaydeaths;
      statewise = instance.statewise;
      casetimeseries = instance.casetimeseries;
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getRefreshedData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    countries = data['countries'];
    countryData = data['countryData'];
    if (infected == null) {
      getCountryData('India');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // bottomNavigationBar: getNavBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshList();
        },
        key: refreshKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyHeader(
                image: 'assets/icons/Drcorona.svg',
                textTop: 'All you need is',
                textBottom: 'stay at home',
                navigator: '/info',
              ),
              // ---------------------- World Data -----------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'World Update\n',
                                style: kTitleTextStyle.copyWith(
                                    // letterSpacing: 1.0,
                                    fontFamily: "GothamBook"
                                    ),
                              ),
                              TextSpan(
                                text:
                                    'Last Updated: ${DateFormat("MMMM dd, y,").add_jm().format(now)}',
                                style: TextStyle(
                                  color: kTextLightColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Counter(
                            color: Colors.orange[500],
                            number1: data['world_cases'],
                            number2: data['world_todaycases'],
                            title: 'Infected',
                          ),
                          Counter(
                            color: kDeathColor,
                            number1: data['world_deaths'],
                            number2: data['world_todaydeaths'],
                            title: 'Deaths',
                          ),
                          Counter1(
                            color: kRecovercolor,
                            number1: data['world_recovered'],
                            title: 'Recovered',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // -------------------------- Countries Data -------------------
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Countries Update\n',
                                style:
                                    kTitleTextStyle.copyWith(fontFamily: "GothamBook"),
                              ),
                              TextSpan(
                                text:
                                    'Last Updated: ${DateFormat("MMMM dd, y,").add_jm().format(now)}',
                                style: TextStyle(
                                  color: kTextLightColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            createInterstitialAd()
                              ..load()
                              ..show();
                            Navigator.pushNamed(context, '/cases', arguments: {
                              'infected': infected,
                              'death': death,
                              'recovered': recovered,
                              'country': country,
                              'active': active,
                              'todaycases': todaycases,
                              'tests': tests,
                              'todaydeaths': todaydeaths,
                              'casesPerOneMillion': casesPerOneMillion,
                              'deathsPerOneMillion': deathsPerOneMillion,
                              'testsPerOneMillion': testsPerOneMillion,
                              'url': url,
                            });
                          },
                          child: Text(
                            'See Details',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/maps-and-flags.svg'),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(width: 20),
                        icon: SvgPicture.asset('assets/icons/dropdown.svg'),
                        value: country,
                        items: countries
                                ?.map<DropdownMenuItem<String>>((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })?.toList() ??
                            [],
                        onChanged: (value) async {
                          await getCountryData(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Counter(
                            color: Colors.orange[500],
                            number1: infected,
                            number2: todaycases,
                            title: 'Infected',
                          ),
                          Counter(
                            color: kDeathColor,
                            number1: death,
                            number2: todaydeaths,
                            title: 'Deaths',
                          ),
                          Counter1(
                            color: kRecovercolor,
                            number1: recovered,
                            title: 'Recovered',
                          ),
                        ],
                      ),
                    ),
                    // ------------------------- India State Dropdown-----------------------

                    // ------------------------- India StateWise Data ----------------------
                    SizedBox(height: 30),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'India ST/UT Update',
                                    style: kTitleTextStyle.copyWith(
                                        fontFamily: "GothamBook"),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                createInterstitialAd()
                                  ..load()
                                  ..show();
                                Navigator.pushNamed(context, '/indiastate',
                                    arguments: {
                                      'statewise': statewise,
                                      'casetimeseries': casetimeseries,
                                    });
                              },
                              child: Text(
                                'See Details',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // -------------------------- Spread Map -------------------------------
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text(
                    //       'Spread of Virus',
                    //       style: kTitleTextStyle,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(context, '/googlemaps');
                    //       },
                    //       child: Text(
                    //         'Live Map',
                    //         style: TextStyle(
                    //           color: kPrimaryColor,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
