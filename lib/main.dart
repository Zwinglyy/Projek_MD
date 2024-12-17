import 'package:emisi_md/userManagement/login_.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CarbonMonitoringApp());
}

class CarbonMonitoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Monitor Carbon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
    );
  }
}

