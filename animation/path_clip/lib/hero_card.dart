import 'package:flutter/material.dart';

import 'dashbord.dart';
import 'detailPage.dart';

class HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Stack(
    children: <Widget>[
      InkWell(
      onTap: () {
        Navigator.push(context,
            PageRouteBuilder(pageBuilder: (context, a, b) => DetailPage()));
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipPath(
        clipper: BackgroundClipper(),
        child: Hero(
          tag: "background",
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.46,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrangeAccent],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )),
          ),
        )
      ))
    ),
      Align(
        alignment: Alignment.center,
        child: Image.asset('images/iron_man.png', scale: 1.5,)
      ),
      Positioned(
        bottom: 20,
        left: 80,
        child: Column(
          children: [
            Text(
              "Iron Man", 
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontSize: 32,
              ),
            ),
            Text(
              "Click for more details", 
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white70, 
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            )
          ],
        )
      )
    ]);
  }
}
