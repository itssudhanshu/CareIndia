import 'dart:core';
import 'package:http/http.dart';
import 'dart:convert';

class Resources {
  List<String> states = [];
  List<String> cities = [];
  List<String> services = [];
  List<dynamic> allEssentials = [];
  // List<String> description = [];
  // List<String> phone = [];
  static Response response;
  static Map data;
  static List<dynamic> scrapedData;
  // Data Scraped

  Future<void> allList() async {
    List result1 = [];
    List result2 = [];
    response =
        await get('https://api.covid19india.org/resources/resources.json');
    data = jsonDecode(response.body);
    scrapedData = data['resources'];
    scrapedData.forEach((element) {
      result1.add(element['state']);
      result2.add(element['category']);
    });
    states = [
      ...{...result1}
    ];
    services = [
      ...{...result2}
    ];
  }

  Future<void> cityList(String state) async {
    List result = [];
    scrapedData.forEach((element) {
      if (state == element['state']) {
        result.add(element['city']);
      }
    });
    cities = [
      ...{...result}
    ];
  }

  Future<void> selectedService(String state, String city) async {
    List result = [];
    scrapedData.forEach((element) {
      if (state == element['state']) {
        if (city == element['city']) {
          result.add(element['category']);
        }
      }
    });
    services = [
      ...{...result}
    ];
  }

  Future<void> showDetails(String state, String city, String service) async {
    // List result1 = [], result2 = [], result3 = [];
    scrapedData.forEach((element) {
      if (state == element['state'] &&
          city == element['city'] &&
          service == element['category']) {
        allEssentials.add({
          "organisation": element['nameoftheorganisation'],
          "description": element['descriptionandorserviceprovided'],
          "phone": element['phonenumber']
        });
        // description.add(element['descriptionandorserviceprovided']);
        // phone.add(element['phonenumber']);
      }
    });
  }
}
