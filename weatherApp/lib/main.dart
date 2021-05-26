import 'package:flutter/material.dart';
import 'package:weatherApp/API_manager.dart';
import 'package:weatherApp/carousel.dart';
import 'package:weatherApp/search_city.dart';
import 'package:weatherApp/weather_next_seven_days.dart';
import 'package:weatherApp/weather_per_hour.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Weather> weather;
  String _nameCity;
  @override
  void initState() {
    super.initState();
    _nameCity = "Nanterre, Paris";
    weather = APIManager.fetchWeather("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(115, 161, 249, 1),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                City city = await showSearch<City>(
                    context: context, delegate: Search());
                setState(() {
                  weather = APIManager.fetchWeather(city.insee);
                  _nameCity = city.name;
                });
              },
            )
          ],
          title: Text(_nameCity),
          leading: Icon(
            Icons.location_on,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(115, 161, 249, 1),
        endDrawer: Container(
          color: Colors.blueAccent,
        ),
        body: FutureBuilder<Weather>(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return homeBody(
                  snapshot.data.forcastPeriod, snapshot.data.forecastDay);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Unknow Data",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          },
        ));
  }

  void navigateToMoreWeather(
      BuildContext context, List<WeatherPerDay> weatherPerDay) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeatherNextSevenDays(
                  weatherPerDay: weatherPerDay,
                )));
  }

  Widget homeBody(ForcastPeriod forecastPeriod, ForecastDay forecastDay) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color.fromRGBO(115, 161, 249, 0.9), Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: SafeArea(
          child: Container(
              child: Column(children: [
        Expanded(
          flex: 6,
          child: Carousel(listWeater: forecastPeriod.weatherPerDay),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.20,
            child: WeatherPerHour(weatherPerDay: forecastDay.weatherPerDay),
          ),
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () =>
                      navigateToMoreWeather(context, forecastDay.weatherPerDay),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(159, 217, 252, 0.5),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            "Next 7 days",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        )),
                  ),
                ))),
      ]))),
    );
  }
}
