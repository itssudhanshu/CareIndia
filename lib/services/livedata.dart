import 'dart:core';
import 'package:http/http.dart';
import 'dart:convert';

class LiveData {
  int worldCases;
  int worldDeaths;
  int worldRecovered;
  int worldTodaycases;
  int worldTodaydeaths;
  List<String> allCountries = [];
  List<dynamic> statewise = [];
  List<dynamic> casetimeseries = [];
  List<dynamic> countryData = [];

  Future<void> countryList() async {
    Response response = await get('https://corona.lmao.ninja/v2/countries');
    List<dynamic> data = jsonDecode(response.body);
    data.forEach((element) {
      allCountries.add(element['country']);
    });
  }

  Future<void> getCountryData() async {
    Response response = await get('https://corona.lmao.ninja/v2/countries');
    countryData = jsonDecode(response.body);
  }

  Future<void> getData() async {
    try {
      // make a request

      Response res = await get('https://disease.sh/v2/all');
      Map result = jsonDecode(res.body);
      worldCases = result['cases'];
      worldDeaths = result['deaths'];
      worldRecovered = result['recovered'];
      worldTodaycases = result['todayCases'];
      worldTodaydeaths = result['todayDeaths'];

      Response r = await get('https://api.covid19india.org/data.json');
      Map statewisedata = jsonDecode(r.body);
      List<dynamic> scrap1 = statewisedata['statewise'];
      List<dynamic> scrap2 = statewisedata['cases_time_series'];
      scrap1.forEach((element) {
        statewise.add(element);
      });
      scrap2.forEach((element) {
        casetimeseries.add(element);
      });
    } catch (e) {
      print('caught error: $e');
    }
  }
}
