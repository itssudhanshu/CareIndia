import 'package:CareIndia/constants.dart';
import 'package:CareIndia/services/resources.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String _state;
  String _city;
  String _service;
  List<String> cities;
  List<String> states;
  List<String> services;
  List<dynamic> allessential = [];
  Widget table = AdmobBanner(
      adUnitId: "ca-app-pub-8046768523927143/1839579835",
      adSize: AdmobBannerSize.LARGE_BANNER);
  GlobalKey<RefreshIndicatorState> refreshKey;

  // List<String> description;
  // List<String> phone;

  //get all the details of resources by using function
  void getState() async {
    Resources instance = Resources();
    await instance.allList();
    setState(() {
      states = instance.states;
      services = instance.services;
    });
  }

  void getCity(String value) async {
    Resources instance = Resources();
    await instance.cityList(value);
    setState(() {
      cities = instance.cities;
    });
  }

  void getService(String state, String city) async {
    Resources instance = Resources();
    await instance.selectedService(state, city);
    setState(() {
      services = instance.services;
    });
  }

  Future<void> getdetails(String state, String city, String service) async {
    Resources instance = Resources();
    await instance.showDetails(state, city, service);
    setState(() {
      allessential = instance.allEssentials;
      // print(allessential);
    });
  }

  // Refresh Function using key
  Future<void> getFeed() async {
    getState();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    await getFeed();
    return null;
  }

  // Data Table body
  DataTable dataBody() {
    return DataTable(
      dataRowHeight: 120.0,
      headingRowHeight: 30.0,
      columnSpacing: 5,
      // headingFontSize: 20,
      columns: [
        DataColumn(
          label: Container(
            width: 100,
            child: Text(
              'ORGANISATION',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: false,
          tooltip: "Name of the Organisation",
        ),
        DataColumn(
          label: Text(
            'DESCRIPTION',
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          numeric: false,
          tooltip: "Description of Organisation",
        ),
        DataColumn(
          label: Text(
            'PHONE',
            // textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          numeric: true,
          tooltip: "Contact Details of Organisation",
        ),
      ],
      rows: allessential
              ?.map((element) => DataRow(cells: [
                    DataCell(
                      Container(
                        width: 100,
                        child: Text(
                          element['organisation'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 150,
                        child: Text(
                          element['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                        Text(
                          element['phone'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ), onTap: () {
                      UrlLauncher.launch('tel:+91' + element['phone']);
                    }),
                  ]))
              ?.toList() ??
          [],
    );
  }

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getState();
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
              'Essentials',
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
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshList();
        },
        key: refreshKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                    color: Colors.black,
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
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Text('Select State'),
                        value: _state,
                        items: states
                                ?.map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                ?.toList() ??
                            [],
                        onTap: () {
                          // print('Yes');
                          _city = null;
                          _service = null;
                        },
                        onChanged: (String value) {
                          setState(() {
                            _state = value;
                            getCity(value);
                            print(_state);
                            // print(cities);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ------------------Cities Dropdown -----------------------
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/maps-and-flags.svg'),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        underline: SizedBox(width: 20),
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Text('Select City'),
                        value: _city,
                        items: cities
                                ?.map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                ?.toList() ??
                            [],
                        onTap: () {
                          print('Yes');
                          _service = null;
                        },
                        onChanged: (value) async {
                          setState(() {
                            _city = value;
                            getService(_state, _city);
                            print(_city);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ------------------- Select Services -----------------------
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/maps-and-flags.svg'),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        underline: SizedBox(width: 20),
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Text('Select Service'),
                        value: _service,
                        items: services
                                ?.map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                ?.toList() ??
                            [],
                        onTap: () {
                          print('Yes');
                        },
                        onChanged: (value) async {
                          setState(() {
                            _service = value;
                            // getService(_state, _city);
                            print(_service);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // --------------------- Search & Feedback Button ------------------
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 0, 3, 20),
                            Color.fromARGB(255, 25, 200, 219),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: FlatButton.icon(
                        label: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontSize: 15,
                          ),
                        ),
                        icon: Icon(
                          EvilIcons.search,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await getdetails(_state, _city, _service);
                          setState(() {
                            table = dataBody();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 0, 3, 20),
                            Color.fromARGB(255, 25, 200, 219),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: FlatButton.icon(
                        label: Text(
                          'Feedback',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontSize: 15,
                          ),
                        ),
                        icon: Icon(
                          Icons.feedback,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          Navigator.of(context)
                              .pushNamed('/feedback', arguments: {
                            'form_name': 'Feedback',
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              // ----------------- Data Table ------------------------
              SizedBox(height: 20),
              Material(
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 6),
                        blurRadius: 30,
                        color: kShadowColor,
                      ),
                    ],
                  ),
                  child: FittedBox(
                    child: table,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
