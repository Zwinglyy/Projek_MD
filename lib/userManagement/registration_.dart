import 'package:flutter/material.dart';
import 'package:emisi_md/api_service_.dart';
import 'package:emisi_md/userManagement/login_.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ApiService apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String phoneNumber = '';
  String address = '';
  String pqAnswer = '';
  String? selectedPQId;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordMatching = true;
  bool _isLoading = false;

  List<Map<String, dynamic>> questions = [];

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_checkPasswordMatch);
    _loadQuestions();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordMatch() {
    setState(() {
      _isPasswordMatching = _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final fetchedQuestions = await apiService.getQuestions();
      setState(() {
        questions = fetchedQuestions;
        selectedPQId = questions.isNotEmpty ? questions.first['pqId'] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading security questions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Register New Account',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Username',
                    onSaved: (value) => userName = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter User Name' : null,
                  ),
                  SizedBox(height: 12),
                  _buildPasswordField(),
                  SizedBox(height: 12),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 12),
                  _buildTextField(
                    label: 'Phone number',
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => phoneNumber = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter Telephone Number' : null,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    label: 'address',
                    maxLines: 3,
                    onSaved: (value) => address = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
                  ),
                  SizedBox(height: 12),
                  _buildPQDropdown(),
                  SizedBox(height: 12),
                  _buildPQAnswerField(),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                  SizedBox(height: 12),
                  _buildLoginPrompt(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
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
      validator: (value) =>
          value!.isEmpty ? 'Please enter your password' : null,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isConfirmPasswordVisible,
      validator: (value) {
        if (value!.isEmpty) return 'Please confirm your password';
        if (!_isPasswordMatching) return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildPQDropdown() {
    return Container(
      width: double.infinity, // Lebar penuh
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Menambah padding agar lebih lega
      child: DropdownButtonFormField<String>(
        isExpanded: true, // Menghindari teks terpotong
        value: selectedPQId,
        decoration: InputDecoration(
          labelText: 'Select Security Questions',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Tinggi field diperbesar
        ),
        items: questions.map((question) {
          return DropdownMenuItem<String>(
            value: question['pqId'], // Pastikan ini tipe String
            child: Text(
              question['pqQuestion'] ?? '',
              style: TextStyle(fontSize: 14),
              maxLines: 2, // Mengizinkan teks multi-baris
              overflow: TextOverflow.ellipsis, // Tambahkan elipsis jika teks terlalu panjang
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedPQId = value!;
          });
        },
        validator: (value) =>
        value == null ? 'Please select a security question' : null,
      ),
    );
  }

  Widget _buildPQAnswerField() {
    return _buildTextField(
                    label: 'Your answer',
                    maxLines: 3,
                    onSaved: (value) => pqAnswer = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your answer' : null,
                  );
  }

  Widget _buildSubmitButton() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _register,
            child: Center(
              child: Text(
                'register',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text(
            'Log in ',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await apiService.registerUser(
          action: "registerUser",
          dateTime: DateTime.now().toIso8601String(),
          userName: userName,
          userPasswd: _passwordController.text,
          phoneNumber: phoneNumber,
          address: address,
          pqId: selectedPQId!,
          pqAnswer: pqAnswer,
        );

        if (response['status'] == 'SUCCESS') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pendaftaran Berhasil'),
                content: Text('Akun Anda telah berhasil dibuat.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Gagal mendaftar')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
