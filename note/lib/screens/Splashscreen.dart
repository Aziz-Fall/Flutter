import 'package:flutter/material.dart';
import 'package:note/screens/NoteApp.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
          loaderColor: Colors.deepPurple,
          seconds: 10,
          title: Text(
            "NOTE'S",
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'fonts/BebasNeue-Regular',
              shadows: [
                Shadow(
                  offset: Offset(5.0, 2.0),
                  blurRadius: 5.0,
                  color: Colors.black26), 
                Shadow(
                  color: Colors.deepPurple[100]
                )]
            ),
          ),
          backgroundColor: Colors.white,
          navigateAfterSeconds: NoteApp(),
    );
  }
}
