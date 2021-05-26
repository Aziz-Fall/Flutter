import 'package:flutter/material.dart';
import 'package:weatherApp/API_manager.dart';
import 'package:weatherApp/const.dart';

class WeatherNextSevenDays extends StatefulWidget {
  final List<WeatherPerDay> weatherPerDay;
  WeatherNextSevenDays({this.weatherPerDay});
  @override
  State<StatefulWidget> createState() => _WeatherNextSevenDaysState();
}

class _WeatherNextSevenDaysState extends State<WeatherNextSevenDays> {
  List<WeatherPerDay> listWeather = List<WeatherPerDay>();

  @override
  void initState() {
    super.initState();
    for (var i = 4; i < 11; i++) {
      listWeather.add(widget.weatherPerDay[i]);
    }
    debugPrint("Length: " + listWeather.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 50, left: 10),
              child: ListTile(
                  leading: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () => _navigateToHome(context),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: Text(
                      "Nanterre, France",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'fonts/MavenPro-Regular.ttf',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )),
            Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Next 7 Days",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: getListView(),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pop(context);
  }

  ListView getListView() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: listWeather.length,
        itemBuilder: (context, index) {
          return Container(
              child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset(
                        getPathImage(listWeather[index].weather),
                        scale: 3.6,
                      )),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Text(
                        getDay(listWeather[index].date),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        getDayMonth(listWeather[index].date),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 20,
                        ),
                      )),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        listWeather[index].temperature.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      )),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        "/ ${listWeather[index].temperatureMin}°",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                          fontSize: 20,
                        ),
                      )),
                ),
              ],
            ),
          ));
        });
  }
}
