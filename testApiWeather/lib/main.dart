import 'package:flutter/material.dart';
import 'package:testApiWeather/API_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Weather> weather;

  @override
  void initState() {
    super.initState();
    weather = APIManager.fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Weather>(
          future: weather,
          builder: (context, snapshot) {
            debugPrint("In build method");
            debugPrint("${snapshot.hasData}");
            if (snapshot.hasData) {
              List<DayPeriodWeather> p =
                  snapshot.data.forcastPeriod.weatherPerDay;
              for (var item in p) {
                debugPrint("finaly: " + item.temperature.toString());
              }
              // List<WeatherPerDay> dayPeriod =
              //     snapshot.data.forecastDay.weatherPerDay;
              // for (var item in dayPeriod) {
              //   debugPrint("item: " + item.weather.toString() + " °C");
              // }
            } else if (snapshot.hasError) {
              debugPrint("In else blog");
              throw Exception("Error data");
            }

            return CircularProgressIndicator();
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView getList(BuildContext context, List listDay) {
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.cloud),
        title: Text(listDay[index].temperature),
      );
    });
  }
}
