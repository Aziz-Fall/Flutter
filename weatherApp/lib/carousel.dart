import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherApp/const.dart';

import 'API_manager.dart';

class Carousel extends StatefulWidget {
  final List<DayPeriodWeather> listWeater;
  Carousel({this.listWeater});
  @override
  State<StatefulWidget> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<Widget> listItems = List<Widget>();

  @override
  void initState() {
    super.initState();
    for (var weather in widget.listWeater) {
      debugPrint("Weater carrousell: " + weather.period.toString());
      listItems.add(item(weather));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: listItems,
        options: CarouselOptions(
          height: 500,
          aspectRatio: 16 / 9,
          viewportFraction: 1.0,
          initialPage: 2,
          enableInfiniteScroll: true,
          reverse: true,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ));
  }

  String getPeriod(int period) {
    switch (period) {
      case 1:
        return "Matin";
      case 0:
        return "Midi";
      case 3:
        return "Soir";
      default:
        return "Nuit";
    }
  }

  Widget item(DayPeriodWeather dayPeriodDay) {
    var date = DateTime.parse(dayPeriodDay.date);
    var formatDate = DateFormat.yMMMd().format(date);

    return Center(
        child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(159, 217, 252, 0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      getPeriod(dayPeriodDay.period),
                      style: TextStyle( 
                        color: Colors.white,
                        fontSize: 20
                      ),
                  )
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Image.asset(
                    getPathImage(dayPeriodDay.weather),
                    scale: 1.5,
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Text(
                        WEATHER[dayPeriodDay.weather],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0, top: 10),
                    child: Text(
                      formatDate, // DATE
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 0, top: 10),
                      child: Center(
                        child: Text(
                          dayPeriodDay.temperature.toString() + "°",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      )),
                ),
                Flexible(
                  flex: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Image.asset("images/wind.png",
                              scale: 0.8, color: Colors.white)),
                      Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                              dayPeriodDay.windSpeed.toString() + " km/h",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white))),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset("images/humidity.png",
                            scale: 0.8, color: Colors.white),
                      ),
                      Text("68 %",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                )
              ],
            )));
  }
}
