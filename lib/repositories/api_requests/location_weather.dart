import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_boilerplate/infrastructure/core/helper.dart';
import 'package:flutter_app_boilerplate/infrastructure/sources/remote/api/api_request.dart';
import 'package:flutter_app_boilerplate/infrastructure/sources/remote/api/api_response.dart';
import 'package:flutter_app_boilerplate/models/infrastructure/weather.dart';
import 'package:http/http.dart';

/// The API request
class WeatherApiProvider extends APIRequest {
  Future<APIResponse> fromLocation({
    @required String location,
  }) async {
    final Response response = await get(
      "https://samples.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(location)}&appid=b6907d289e10d714a6e88b30761fae22",
    );
    return _Response(response);
  }
}

/// The API Response
class _Response extends APIResponse {
  /// weather details
  double temp;
  double tempMin;
  double tempMax;
  double pressure;
  double humidity;
  Map<String, double> wind;

  /// location details
  String name;
  Map<String, double> coordinates;

  /// location weather
  List<Weather> weather;

  /// handle parsing the API response and creating the response instance
  _Response(Response response) : super(response) {
    final Map<String, dynamic> main = body['main'] as Map<String, double>;

    /// weather details
    temp = Helper.getDouble(main['temp']);
    tempMin = Helper.getDouble(main['temp_min']);
    tempMax = Helper.getDouble(main['temp_max']);
    pressure = Helper.getDouble(main['pressure']);
    humidity = Helper.getDouble(main['humidity']);
    wind = body['wind'] as Map<String, double>;

    /// location details
    coordinates = body['coord'] as Map<String, double>;
    weather = parseWeather();
  }

  /// Handles parsing of the weather data
  List<Weather> parseWeather() {
    final List<Weather> _list = [];

    for (final dynamic weather in body['weather'] as List) {
      _list.add(Weather.fromJson(weather));
    }

    return _list;
  }
}
