import 'dart:core';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:time_ago_provider/time_ago_provider.dart';

class FeedLogs {
  List<dynamic> updatetime = [];

  Future<void> getFeeds() async {
    Response response =
        await get('https://api.covid19india.org/updatelog/log.json');
    List<dynamic> data = jsonDecode(response.body);

    var now = new DateTime.now();
    var today = DateFormat('d MMM').format(now);

    data.forEach((element) {
      var format = new DateFormat('d MMM');
      var date =
          new DateTime.fromMillisecondsSinceEpoch(element['timestamp'] * 1000);
      if (today.toString() == format.format(date).toString()) {
        updatetime.insert(0, {
          "update": element['update'],
          "time": TimeAgo.getTimeAgo(element['timestamp']),
          "date": format.format(date)
        });
      }
    });
  }
}
