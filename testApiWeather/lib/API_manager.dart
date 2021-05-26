import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const String key =
    "3574348806ca077bc4aa5ab4bb67b7ff496562e3a539f52d58694c384937a5f2";
const String city = "Paris";
const String requestLocationCities =
    "https://api.meteo-concept.com/api/location/cities?token=" +
        key +
        "&search=" +
        city;
String weatherPerDay =
    "https://api.meteo-concept.com/api/forecast/daily?token=" + key + "&insee=";
// Weather per period for 14 days
String requestForcastPeriod =
    "https://api.meteo-concept.com/api/forecast/daily/0/periods?token=" +
        key +
        "&insee=";

class City {
  String _name;
  int _cp;
  String _insee;

  get name => _name;
  get cp => _cp;
  get insee => _insee;

  City(this._name, this._cp, this._insee);

  factory City.fromJson(Map<String, dynamic> json) {
    return City(json['name'], json['cp'], json['insee']);
  }
}

class Update {
  String _date;

  Update(this._date);

  get date => _date;
}

class DayPeriodWeather {
  int _period;
  String _date;
  int _day;
  int _temperature;
  int _windSpeed;

  get period => _period;
  get date => _date;
  get day => _day;
  get temperature => _temperature;
  get windSpeed => _windSpeed;

  DayPeriodWeather(
      this._period, this._date, this._day, this._temperature, this._windSpeed);

  factory DayPeriodWeather.fromJson(Map<String, dynamic> json) =>
      DayPeriodWeather(json['period'], json['datetime'], json['day'],
          json['temp2m'], json['wind10m']);
}

class ForecastDay {
  List<WeatherPerDay> _weatherPerDay;

  get weatherPerDay => _weatherPerDay;

  ForecastDay(this._weatherPerDay);

  factory ForecastDay.fromList(List<dynamic> list) => ForecastDay(
      List<WeatherPerDay>.from(list.map((e) => WeatherPerDay.fromJson(e))));
}

class Weather {
  Update _update;
  City _city;
  ForcastPeriod _forcastPeriod;
  ForecastDay _forecastDay;

  get update => _update;
  get city => _city;
  get forcastPeriod => _forcastPeriod;
  get forecastDay => _forecastDay;

  Weather(this._city, this._forcastPeriod, this._update, this._forecastDay);

  factory Weather.fromJson(Map<String, dynamic> jsonForecastPeriond, Map<String, dynamic> jsonForecastDay) => Weather(
      City.fromJson(jsonForecastPeriond['city']),
      ForcastPeriod.fromJson(jsonForecastPeriond['forecast']),
      Update(jsonForecastPeriond['update']),
      ForecastDay.fromList(jsonForecastDay['forecast']));
}

class WeatherPerDay {
  int _day;
  String _date;
  int _windSpeed;
  int _weather;
  int _temperature;

  get day => _day;
  get date => _date;
  get windSpeed => _windSpeed;
  get weather => _weather;
  get temperature => _temperature;

  WeatherPerDay(
      this._day, this._date, this._windSpeed, this._weather, this._temperature);

  factory WeatherPerDay.fromJson(Map<String, dynamic> json) {
    return WeatherPerDay(json['day'], json['datetime'], json['wind10m'],
        json['weather'], json['tmax']);
  }
}

class ForcastPeriod {
  List<DayPeriodWeather> _weatherPerDay;

  get weatherPerDay => _weatherPerDay;

  ForcastPeriod(this._weatherPerDay);

  factory ForcastPeriod.fromJson(List list) {
   return ForcastPeriod(List<DayPeriodWeather>.from(list.map((e) => DayPeriodWeather.fromJson(e))));
  }
}

class Cities {
  List<City> _cities;

  get listCities => _cities;

  Cities(this._cities);

  factory Cities.fromJson(Map<String, dynamic> json) =>
      Cities(List<City>.from(json['cities'].map((x) => City.fromJson(x))));
}

class APIManager {
  static Future<Weather> fetchWeather() async {
    var responses = await http.get(requestLocationCities);

    if (responses.statusCode != 200) {
      throw Exception("Failled to load a city Weather");
    } else {
      debugPrint("responses cities is done");
    }

    Cities cities = Cities.fromJson(jsonDecode(responses.body));
    if (cities != null) {
      debugPrint("not null");
      requestForcastPeriod = requestForcastPeriod + cities.listCities[0].insee;
    }
    var responses2 = await http.get(weatherPerDay + cities.listCities[0].insee);
    responses = await http.get(requestForcastPeriod);

    if (responses.statusCode != 200) {
      throw Exception("Failled to load the weather");
    } else {
      debugPrint("responses  is done");
    }

    if (responses2.statusCode != 200) {
      throw Exception("Failled to load the weather");
    } else {
      debugPrint("responses 2 is done");
    }
    debugPrint("Good request....");
    return Weather.fromJson(jsonDecode(responses.body), jsonDecode(responses2.body));
  }
}
