import 'dart:ui';
import 'package:CareIndia/constants.dart';
import 'package:CareIndia/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:pie_chart/pie_chart.dart';

class CaseDetails extends StatefulWidget {
  @override
  _CaseDetailsState createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails> {
  Map<String, double> dataMap = new Map();
  Map data = {};
  List<Color> colorList = [
    kInfectedColor,
    Colors.black,
    kRecovercolor,
    Colors.amber,
    Colors.cyanAccent,
    Colors.red[900],
  ];

  void chartInfo() async {
    dataMap.putIfAbsent("Infected", () => data['infected'].toDouble());
    dataMap.putIfAbsent("Deaths", () => data['death'].toDouble());
    dataMap.putIfAbsent("Recovered", () => data['recovered'].toDouble());
    dataMap.putIfAbsent(
        "Todays's Cases",
        () => data['todaycases'] == null
            ? 0.0000
            : data['todaycases'].toDouble());
    dataMap.putIfAbsent(
        "Todays's Deaths",
        () => data['todaydeaths'] == null
            ? 0.0000
            : data['todaydeaths'].toDouble());
    dataMap.putIfAbsent("Active", () => data['active'].toDouble());
    // dataMap.putIfAbsent("Total Tests", () => data['tests'].toDouble());
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    chartInfo();

    double recoverRate = ((data['recovered'] / data['infected']) * 100);
    double deathRate = ((data['death'] / data['infected']) * 100);
    String url = data['url'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  url,
                  width: 40,
                ),
                SizedBox(width: 10),
                Text(
                  data['country'],
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 1000),
                chartLegendSpacing: 20.0,
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                showChartValuesInPercentage: false,
                showChartValues: false,
                showChartValuesOutside: false,
                chartValueBackgroundColor: Colors.transparent,
                colorList: colorList,
                showLegends: true,
                legendPosition: LegendPosition.right,
                decimalPlaces: 0,
                showChartValueLabel: true,
                initialAngle: 0,
                chartValueStyle: defaultChartValueStyle.copyWith(
                  color: Colors.blueGrey[900].withOpacity(0.9),
                ),
                chartType: ChartType.ring,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 6),
                    blurRadius: 30,
                    color: kShadowColor,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RateCard(rate: recoverRate, title: 'Recovery Rate'),
                      RateCard(rate: deathRate, title: 'Death Rate'),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Counter(
                        color: Colors.orange[500],
                        number1: data['infected'],
                        number2: data['todaycases'],
                        title: 'Infected',
                      ),
                      Counter1(
                        color: kDeathColor,
                        number1: data['active'],
                        title: 'Active',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Counter(
                        color: Colors.red[500],
                        number1: data['death'],
                        number2: data['todaydeaths'],
                        title: 'Death',
                      ),
                      Counter1(
                        color: kRecovercolor,
                        number1: data['recovered'],
                        title: 'Recovered',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SingleValueCards(
                          value: data['tests'], title: 'Total Test Performed'),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Text(
                      'Stats Per One Million',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SingleValueCards(
                          value: data['casesPerOneMillion'], title: 'Cases'),
                      SingleValueCards(
                          value: data['deathsPerOneMillion'], title: 'Deaths'),
                      SingleValueCards(
                          value: data['testsPerOneMillion'], title: 'Tests'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RateCard extends StatelessWidget {
  final double rate;
  final String title;
  const RateCard({
    Key key,
    this.rate,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${rate.toStringAsFixed(2)} %',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}

class SingleValueCards extends StatelessWidget {
  final int value;
  final String title;
  const SingleValueCards({
    Key key,
    this.value,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '$value',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
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
