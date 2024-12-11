import 'package:flutter/material.dart';
import 'package:emisi_md/api_service.dart';
import 'package:emisi_md/authedPage.dart';
import 'package:emisi_md/userManagement/registration_page.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userPasswd = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID Pengguna'),
                onSaved: (value) => userName = value!,
                validator: (value) => value!.isEmpty ? 'Masukkan ID Pengguna' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Kata Sandi'),
                obscureText: true,
                onSaved: (value) => userPasswd = value!,
                validator: (value) => value!.isEmpty ? 'Silakan masukkan Kata Sandi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      final response = await apiService.loginUser(
                        action: "loginUser",
                        userName: userName,
                        userPasswd: userPasswd,
                      );

                      if (response['status'] == 'SUCCESS') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil Masuk')),
                        );
                        // Navigate to authenticated page after successful login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthedPage(userName: userName, userData: response,),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('gagal masuk: ${response['msg']}')),
                        );
                      }

                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text('Masuk'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text('Tidak punya akun? Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
