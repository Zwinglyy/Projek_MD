import 'package:emisi_md/api_service.dart';
import 'package:flutter/material.dart';
import 'package:emisi_md/userManagement/login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ApiService apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userPasswd = '';
  String phoneNumber = '';
  bool _isPasswordVisible = false; // To track the password visibility state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pendaftaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'nama pengguna'),
                onSaved: (value) => userName = value!,
                validator: (value) => value!.isEmpty ? 'Silakan masukkan Nama Pengguna' : null,
              ),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'kata sandi',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                onSaved: (value) => userPasswd = value!,
                validator: (value) => value!.isEmpty ? 'Silahkan masukkan Kata sandi anda' : null,
              ),
              
              TextFormField(
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                onSaved: (value) => phoneNumber = value!,
                validator: (value) => value!.isEmpty ? 'Silahkan memasukkan Nomor HP' : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      final response = await apiService.registerUser(
                        action: "registerUser",
                        dateTime: DateTime.now().toIso8601String(),
                        userName: userName,
                        userPasswd: userPasswd,
                        phoneNumber: phoneNumber,
                      );

                      if (response['status'] == 'SUCCESS') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('pendaftaran berhasil!')),
                        );
                        Navigator.pop(context); // Navigate back after registration
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pendaftaran Gagal: ${response['message']}')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text('Daftar'),
              ),

              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to the login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Sudah memiliki akun? masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
