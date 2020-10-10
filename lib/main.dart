import 'package:esp_tiles/common/app_constant.dart';
import 'package:esp_tiles/common/bloc_observer.dart';
import 'package:esp_tiles/module/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(ImperoApp());
}

class ImperoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.black,
      ),
      home: HomePage(),
    );
  }
}
