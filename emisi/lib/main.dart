import 'package:emisi/authedPage.dart';
import 'package:emisi/userManagement/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:emisi/userManagement/login_page.dart';

void main() {
  runApp(ExpenseMonitoringApp());
}

class ExpenseMonitoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CARBON CALCULATOR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}

