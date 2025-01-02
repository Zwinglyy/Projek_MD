import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../api_service_.dart';
import 'login_.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
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
  late AnimationController _controller;

  List<Map<String, dynamic>> questions = [];

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _confirmPasswordController.addListener(_checkPasswordMatch);
    _loadQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(Color(0xFFFF0000), Color(0xFFFFA500), _controller.value)!,
                  Color.lerp(Color(0xFFFFA500), Color(0xFFFFFF00), _controller.value)!,
                  Color.lerp(Color(0xFFFFFF00), Color(0xFF00FF00), _controller.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'image/MoCa Logo.png',
                  width: 100,
                  height: 200,
                ),
                SizedBox(height: 10),
                Text(
                  'Register New Account',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Username', (value) => userName = value!),
                        SizedBox(height: 15),
                        _buildPasswordField('Password', _passwordController, _isPasswordVisible, () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        }),
                        SizedBox(height: 15),
                        _buildPasswordField('Confirm Password', _confirmPasswordController, _isConfirmPasswordVisible, () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        }, !_isPasswordMatching ? 'Passwords do not match' : null),
                        SizedBox(height: 15),
                        _buildTextField('Phone Number', (value) => phoneNumber = value!),
                        SizedBox(height: 15),
                        _buildTextField('Address', (value) => address = value!, maxLines: 3),
                        SizedBox(height: 15),
                        _buildPQDropdown(),
                        SizedBox(height: 15),
                        _buildTextField('Your Answer', (value) => pqAnswer = value!),
                        SizedBox(height: 20),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3DD598),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _register,
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: GoogleFonts.poppins(
                      color: Colors.black54,
                    )),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text('Log in',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, FormFieldSetter<String> onSaved, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      onSaved: onSaved,
      validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, VoidCallback onPressed, [String? errorText]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onPressed,
        ),
        errorText: errorText,
      ),
      obscureText: !isVisible,
      validator: (value) => value!.isEmpty ? 'Enter your $label' : null,
    );
  }

  Widget _buildPQDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedPQId,
      decoration: InputDecoration(
        labelText: 'Select Security Question',
        border: OutlineInputBorder(),
      ),
      items: questions.map((q) {
        return DropdownMenuItem<String>(
          value: q['pqId'],
          child: Text(q['pqQuestion'] ?? ''),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedPQId = value!),
      validator: (value) => value == null ? 'Please select a question' : null,
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final dateTime = DateTime.now().toIso8601String();
        final response = await apiService.registerUser(
          action: 'registerUser',
          dateTime: dateTime,
          userName: userName,
          userPasswd: _passwordController.text,
          phoneNumber: phoneNumber,
          address: address,
          pqId: selectedPQId!,
          pqAnswer: pqAnswer,
        );

        if (response['status'] == 'SUCCESS') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Registration failed')),
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
