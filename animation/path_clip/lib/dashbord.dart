import 'package:flutter/material.dart';
import 'package:path_clip/hero_card.dart';

import 'detailPage.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MCU App',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold,
                letterSpacing: 3
              ),
            ),
            Text(
              'Super Heroes',
              style: TextStyle(
                fontSize: 32, 
                letterSpacing: 3,
              ),
            ),
            Expanded(
              child: HeroCard()
            )
          ])
        )
      );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;
    var path = Path();

    path.moveTo(0, size.height * 0.33);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(0, size.height, 50, size.height);

    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - roundnessFactor);

    path.lineTo(size.width, roundnessFactor * 2);

    path.quadraticBezierTo(
        size.width, 0, size.width - roundnessFactor * 3, roundnessFactor * 2);

    path.lineTo(roundnessFactor, size.height * 0.45);
    path.quadraticBezierTo(0, size.height * 0.40 + roundnessFactor, 0,
        size.height * 0.45 + roundnessFactor * 2);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    throw UnimplementedError();
  }
}
