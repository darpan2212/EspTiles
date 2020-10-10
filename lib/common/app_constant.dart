import 'package:flutter/cupertino.dart';

class AppConstants extends InheritedWidget {
  static AppConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  AppConstants({Widget child, Key key}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  get title => 'EST Tiles';
  get baseUrl => 'http://esptiles.imperoserver.in/api/API/';
  get deviceManufacturer => 'Google';
  get deviceModel => 'Android SDK built for x86';
}
