
import 'package:emisi_md/Home.dart';
import 'package:emisi_md/Splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CarbonMonitoringApp());
}

class CarbonMonitoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CARBON CALCULATOR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
    );
  }
}

