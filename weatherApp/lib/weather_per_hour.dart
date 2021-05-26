import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherApp/API_manager.dart';

import 'const.dart';

class WeatherPerHour extends StatefulWidget {
  final List<WeatherPerDay> weatherPerDay;
  WeatherPerHour({this.weatherPerDay});
  @override
  State<StatefulWidget> createState() => _WeatherPerHourState();
}

class _WeatherPerHourState extends State<WeatherPerHour> {
  List<WeatherPerDay> weatherPerDay = List<WeatherPerDay>();

  @override
  void initState() {
    super.initState();
    for (var i = 1; i < 4; i++) {
      weatherPerDay.add(widget.weatherPerDay[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getListWeatherPerHour();
  }

  String getFormatingDate(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  ListView getListWeatherPerHour() {
    return ListView.builder(
        itemCount: weatherPerDay.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_appContext, int index) {
          return Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Column(
                children: [
                  Expanded(
                    child: Text(
                      getDay(weatherPerDay[index].date),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.29,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(159, 217, 252, 0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getFormatingDate(weatherPerDay[index].date),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            getPathImage(weatherPerDay[index].weather),
                            scale: 3.0,
                          
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              weatherPerDay[index].temperature.toString() + "°",
                              style:
                                  TextStyle(fontSize: 35, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
