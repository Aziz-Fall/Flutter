import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;
  ThemeBuilder({this.builder, this.defaultBrightness});

  static _ThemeBuilderState of(BuildContext context) =>
      context.findAncestorStateOfType<_ThemeBuilderState>();
  @override
  State<StatefulWidget> createState() => _ThemeBuilderState();
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness _brightness;
  Brightness _defaultBrightness;
  @override
  void initState() {
    super.initState();
    _brightness = _defaultBrightness;
    if (mounted) {
      setState(() {});
    }
  }

  changeTheme() {
    setState(() {
      _brightness =
          (_brightness == Brightness.dark) ? Brightness.light : Brightness.dark;
    });
  }

  Brightness getCurrentTheme() => _brightness;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
