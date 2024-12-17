import 'package:emisi_md/Home.dart';
import 'package:emisi_md/profilePage_.dart';
import 'package:flutter/material.dart';

class AuthedPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const AuthedPage({required this.userId, required this.userData, Key? key}) : super(key: key);

  @override
  _AuthedPageState createState() => _AuthedPageState();
}

class _AuthedPageState extends State<AuthedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userId: widget.userId,
                    userData: widget.userData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: HomePage(userId: widget.userId),
    );
  }
}