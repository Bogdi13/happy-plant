import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// 192.168.240.100 - hotspot
// 192.168.0.102 - acasa

const String baseUrl = 'http://192.168.240.100:80';

class BaseClient {
  var client = http.Client();

  Future<dynamic> getRealParameters(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);
    debugPrint('RealParameters ${response.statusCode}');
    debugPrint(response.body);
    return response.body;
  }

  Future<dynamic> getPlants(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);
    debugPrint('Plants  ${response.statusCode}');
    debugPrint(response.body);
    return response.body;
  }

  Future<dynamic> getIdealParameters(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);
    debugPrint('IdealParameters ${response.statusCode}');
    debugPrint(response.body);
    return response.body;
  }

  Future<dynamic> getAverageParametersPerWeeek(String api) async {
    var url = Uri.parse(baseUrl + api);
    var response = await http.get(url);
    debugPrint('AverageParametersPerWeek ${response.statusCode}');
    debugPrint(response.body);
    return response.body;
  }
}
