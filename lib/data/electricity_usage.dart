import 'package:http/http.dart'; //dart package: Future-based library for making HTTP requests. https://pub.dev/packages/http
import 'dart:convert'; //dart library: Encoders and decoders for converting between different data representations, including JSON and UTF-8. https://api.dart.dev/stable/2.7.1/dart-convert/dart-convert-library.html
import 'package:intl/intl.dart'; //dart date format package. https://pub.dev/packages/intl

class ElectricityUsage {
  String date;
  int time;
  int odometer = 123456;

  ElectricityUsage({this.date, this.time, this.odometer});

  Future<void> getUsage() async {
    try {
      //make the request

    } catch (e) {
      print('caught error: $e');
    }
  }
}
