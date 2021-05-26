import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;
  ThemeBuilder({this.builder, this.defaultBrightness});

  @override
  State<StatefulWidget> createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness brightness;
  Brightness defaultBrightness;
  @override
  void initState() {
    super.initState();
    brightness = widget.defaultBrightness;
    if( mounted ){
      setState(() {
        
      });
    }
  }

  changeTheme() {
    setState(() {
      brightness =
          (brightness == Brightness.dark) ? Brightness.light : Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, brightness);
  }
}
