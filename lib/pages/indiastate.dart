import 'package:CareIndia/services/livedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Map data = {};

class IndiaStateWise extends StatefulWidget {
  @override
  _IndiaStateWiseState createState() => _IndiaStateWiseState();
}

class _IndiaStateWiseState extends State<IndiaStateWise> {
  int _currentIndex = 0;
  TableData table;
  GraphData graph;
  List<Widget> pages;
  Widget currentPage;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    table = TableData();
    graph = GraphData();

    pages = [table, graph];
    currentPage = table;
    super.initState();
  }

  Future<void> getFeed() async {
    LiveData instance = LiveData();
    await instance.getData();
    setState(() {
      data['statewise'] = instance.statewise;
      data['casetimeseries'] = instance.casetimeseries;
      // print(updatetime[1]);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getFeed();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
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
            child: Text(
              'India Stats\n[State/UT]',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildCustomIconDesign(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: currentPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIconDesign() {
    return Column(
      children: <Widget>[
        CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: Color.fromARGB(255, 19, 92, 112),
          strokeColor: Color.fromARGB(255, 20, 200, 200),
          unSelectedColor: Colors.black87,
          backgroundColor: Colors.grey[100],
          items: [
            CustomNavigationBarItem(
              icon: AntDesign.table,
              // selectedTitle: "Table",
              // unSelectedTitle: "",
            ),
            CustomNavigationBarItem(
              icon: Entypo.line_graph,
              // selectedTitle: "Graphs",
              // unSelectedTitle: "",
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              currentPage = pages[index];
            });
          },
        ),
      ],
    );
  }
}

// ------------------- Table Data StateWise -----------------------

class TableData extends StatefulWidget {
  @override
  _TableDataState createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  List<dynamic> statewise = data['statewise'];

  DataTable dataBody() {
    return DataTable(
      dataRowHeight: 35.0,
      headingRowHeight: 30.0,
      columnSpacing: 5.0,
      // dividerThickness: ,
      horizontalMargin: 5,
      // headingFontSize: 20,
      columns: [
        DataColumn(
          label: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
            width: 80,
            height: 40,
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(5),
              // border: Border.fromBorderSide,
            ),
            child: Text(
              'State',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: false,
          tooltip: "Name of the State",
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: 70,
            height: 40,
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Confirmed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: true,
          tooltip: "Confirmed Cases",
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
            width: 45,
            height: 40,
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Active',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: true,
          tooltip: "Active Cases",
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
            width: 55,
            height: 40,
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Deaths',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: true,
          tooltip: "Deaths Till Now",
        ),
        DataColumn(
          label: Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
            width: 75,
            height: 40,
            // color: Colors.grey[300],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Recovered',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          numeric: true,
          tooltip: "Recovered Cases",
        ),
      ],
      rows: statewise
              ?.map((element) => DataRow(cells: [
                    DataCell(
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 3, 0, 0),
                        width: 80,
                        height: 30,
                        // color: Colors.grey[300],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          element['state'],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.arrow_drop_up,
                                  size: 15, color: Colors.red),
                            ),
                            Text(
                              element['deltaconfirmed'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              element['confirmed'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        element['active'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.arrow_drop_up,
                                  size: 15, color: Colors.red),
                            ),
                            Text(
                              element['deltadeaths'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              element['deaths'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.arrow_drop_up,
                                  size: 15, color: Colors.green),
                            ),
                            Text(
                              element['deltarecovered'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              element['recovered'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]))
              ?.toList() ??
          [],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(statewise[1]['confirmed']);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Material(
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.grey),
              ),
              child: FittedBox(
                child: dataBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------- Graph Data All State ---------------------

class GraphData extends StatefulWidget {
  @override
  _GraphDataState createState() => _GraphDataState();
}

class _GraphDataState extends State<GraphData> {
  // List<dynamic> statewise = data['statewise'];
  // //  statewise.remove(0);
  static List<dynamic> casetimeseries = data['casetimeseries'];
  // static DateTime _getmax = new DateTime.now();
  // print(DateFormat("yyyy,mm,dd").format(_getmax));

  // DateTime _min = DateTime(2020, 01, 28);
  // DateTime _max = DateTime(2020, 05, 01);

  // SfRangeValues _values
  //     SfRangeValues(DateTime(2020, 02, 20), DateTime(2020, 03, 20));
  DateTime now = new DateTime(2020, 01, 27);
  List<Data> _chartData = List<Data>();
  _generateData() {
    casetimeseries.forEach((element) {
      DateTime date = new DateTime(now.year, now.month, now.day + 1);
      Data user = Data(
          date: date,
          confirmed: double.parse(element['dailyconfirmed']),
          deaths: double.parse(element['dailydeceased']),
          recovered: double.parse(element['dailyrecovered']));
      // print(user.confirmed);
      _chartData.add(user);
      now = date;
    });
  }

  @override
  void initState() {
    _generateData();
    // print(_chartData[2].date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(_min);
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(SimpleLineIcons.graph,
                          color: Colors.red[900], size: 20),
                      label: Text("Confirmed",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.red[900]))),
                  FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(SimpleLineIcons.graph,
                          color: Colors.green[900], size: 20),
                      label: Text("Recovered",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.green[900]))),
                  FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(SimpleLineIcons.graph,
                          color: Colors.black87, size: 20),
                      label: Text("Death",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.black87))),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Column Series Graph',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              height: 250,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(15),
                primaryXAxis: DateTimeAxis(isVisible: true),
                primaryYAxis: NumericAxis(isVisible: true),
                plotAreaBorderWidth: 1,
                selectionType: SelectionType.cluster,
                zoomPanBehavior: ZoomPanBehavior(
                    // Enables pinch zooming
                    enablePinching: true),
                enableSideBySideSeriesPlacement: false,
                series: <ColumnSeries<Data, DateTime>>[
                  ColumnSeries<Data, DateTime>(
                    color: Colors.red[900],
                    opacity: 1,
                    width: 0.9,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.confirmed,
                  ),
                  ColumnSeries<Data, DateTime>(
                    color: Colors.black87,
                    // opacity: 0.9,
                    // width: 0.7,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.deaths,
                  ),
                  ColumnSeries<Data, DateTime>(
                    color: Colors.green[900],
                    // opacity: 0.6,
                    // width: 0.5,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.recovered,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Fast Line Graph',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              height: 250,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(15),
                primaryXAxis:
                    DateTimeAxis( isVisible: true),
                primaryYAxis: NumericAxis(isVisible: true),
                plotAreaBorderWidth: 1,
                trackballBehavior: TrackballBehavior(
                    enable: true,
                    // Display mode of trackball tooltip
                    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints),
                zoomPanBehavior: ZoomPanBehavior(
                  // Enables pinch zooming
                  enablePinching: true,
                  enableDoubleTapZooming: true,
                  // Enables the selection zooming
                  enableSelectionZooming: true,
                ),
                series: <ChartSeries>[
                  // Renders fast line chart
                  LineSeries<Data, DateTime>(
                    color: Colors.red[900],
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.confirmed,
                  ),
                  LineSeries<Data, DateTime>(
                    color: Colors.green[900],
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.recovered,
                  ),
                  LineSeries<Data, DateTime>(
                    color: Colors.black87,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.deaths,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Stack Area Graph',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              height: 250,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(15),
                primaryXAxis:
                    DateTimeAxis(isVisible: true),
                primaryYAxis: NumericAxis(isVisible: true),
                plotAreaBorderWidth: 1,
                trackballBehavior: TrackballBehavior(
                    enable: true,
                    // Display mode of trackball tooltip
                    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints),
                zoomPanBehavior: ZoomPanBehavior(
                  // Enables pinch zooming
                  enablePinching: true,
                  enableDoubleTapZooming: true,
                  // Enables the selection zooming
                  enableSelectionZooming: true,
                ),
                series: <ChartSeries<Data, DateTime>>[
                  AreaSeries<Data, DateTime>(
                    color: Colors.red[900],
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.confirmed,
                  ),
                  AreaSeries<Data, DateTime>(
                    color: Colors.green[900],
                    // opacity: 0.5,
                    // width: 0.7,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.recovered,
                  ),
                  AreaSeries<Data, DateTime>(
                    color: Colors.black87,
                    // opacity: 0.2,
                    dataSource: _chartData,
                    xValueMapper: (Data d, _) => d.date,
                    yValueMapper: (Data d, _) => d.deaths,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Data {
  final DateTime date;
  final double confirmed;
  final double deaths;
  final double recovered;

  Data({this.date, this.confirmed, this.deaths, this.recovered});
}
