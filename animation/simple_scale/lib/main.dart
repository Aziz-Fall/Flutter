import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Scale a heart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  var _isChanged = true;
  Icon _icon;
  @override
  void initState() {
    super.initState();
    _icon = Icon(Icons.play_arrow);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 1.0, end: 2).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn
        ));
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  void _changeIcon() {
    if (_isChanged) {
      setState(() {
        _icon = Icon(Icons.pause);
        _isChanged = false;
      });
    } else {
      setState(() {
        _icon = Icon(Icons.play_arrow);
        _isChanged = true;
        _animationController.stop();
      });
    }
  }

  void _animate() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: ScaleTransition(
          scale: _animation,
          child: Image.asset('images/heart.png'),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _animate();
            _changeIcon();
          },
          child: _icon,
        ));
  }
}
