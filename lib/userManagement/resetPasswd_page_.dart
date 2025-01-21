import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:emisi_md/api_service_.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep3 = GlobalKey<FormState>();

  String phoneNumber = '';
  String pqAnswer = '';
  String newPassword = '';
  String retypePassword = '';
  bool isLoading = false;
  String pqQuestion = '';
  String? pqId;
  bool isStep2 = false;
  bool isStep3 = false;
  bool isPQValidated = false;
  bool _isPasswordVisible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(Colors.lightGreen, Colors.teal, _controller.value)!,
              Color.lerp(Colors.teal, Colors.blueAccent, _controller.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: AbsorbPointer(
          absorbing: isLoading,
          child: isLoading
              ? Center(child: CircularProgressIndicator(
              color: Colors.blue,
          ))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isStep2 && !isStep3) _buildStep1(),
                  if (isStep2 && !isPQValidated) _buildStep2(),
                  if (isStep3) _buildStep3(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan Nomor Telepon Anda',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Warna latar belakang untuk TextFormField
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.phone, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Hapus border default
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                filled: true,
                fillColor: Colors.white, // Warna latar belakang tidak transparan
              ),
              onSaved: (value) => phoneNumber = value!,
              validator: (value) =>
              value!.isEmpty ? 'Masukkan nomor telepon Anda' : null,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _validatePhoneNumber,
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3DD598),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pqQuestion,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Warna latar belakang untuk TextFormField
              borderRadius: BorderRadius.circular(12), // Sudut membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Jawaban Anda',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.question_answer, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Hapus border default
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                filled: true,
                fillColor: Colors.white, // Warna latar belakang tidak transparan
              ),
              onSaved: (value) => pqAnswer = value!,
              validator: (value) => value!.isEmpty ? 'Masukkan jawaban' : null,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _verifyPQAnswer,
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.poppins(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3DD598),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStep3() {
    return Form(
      key: _formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan Kata Sandi Baru',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white70, // Warna latar belakang
              borderRadius: BorderRadius.circular(12), // Sudut membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Hapus garis tepi default
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                filled: true,
                fillColor: Colors.white70, // Warna latar belakang tidak transparan
              ),
              onChanged: (value) => newPassword = value,
              validator: (value) => value!.isEmpty ? 'Masukkan kata sandi baru' : null,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white70, // Warna latar belakang
              borderRadius: BorderRadius.circular(12), // Sudut membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Ketik Ulang Kata Sandi',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Hapus garis tepi default
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                filled: true,
                fillColor: Colors.white, // Warna latar belakang tidak transparan
              ),
              validator: (value) =>
              value != newPassword ? 'Kata sandi tidak cocok' : null,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updatePassword,
            child: Text(
              'Perbarui Kata Sandi',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3DD598),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ],
      ),
    );
  }


  void _validatePhoneNumber() async {
    if (_formKeyStep1.currentState!.validate()) {
      _formKeyStep1.currentState!.save();
      setState(() => isLoading = true);
      try {
        final response = await apiService.verifyPhoneNumber(
          action: "verifyPhoneNumber",
          phoneNumber: phoneNumber,
        );
        if (response['status'] == 'SUCCESS') {
          setState(() {
            pqId = response['pqId'];
            pqQuestion = response['pqQuestion'];
            isStep2 = true;
          });
        } else {
          _showErrorSnackbar('Nomor telepon tidak ditemukan');
        }
      } catch (e) {
        _showErrorSnackbar('Terjadi kesalahan: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _verifyPQAnswer() async {
    if (_formKeyStep2.currentState!.validate()) {
      _formKeyStep2.currentState!.save();
      setState(() => isLoading = true);
      try {
        final response = await apiService.validatePQAnswer(
          action: "validatePQAnswer",
          phoneNumber: phoneNumber,
          pqId: pqId!,
          pqAnswer: pqAnswer,
        );
        if (response['status'] == 'SUCCESS') {
          setState(() {
            isPQValidated = true; // Tandai PQ sudah divalidasi
            isStep3 = true;
          });
        } else {
          _showErrorSnackbar('Jawaban pertanyaan pribadi salah');
        }
      } catch (e) {
        _showErrorSnackbar('Terjadi kesalahan: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _updatePassword() async {
    if (_formKeyStep3.currentState!.validate()) {
      _formKeyStep3.currentState!.save();
      setState(() => isLoading = true);
      try {
        final response = await apiService.changePassword(
          action: "changePassword",
          phoneNumber: phoneNumber,
          newPasswd: newPassword,
        );
        if (response['status'] == 'SUCCESS') {
          _showErrorSnackbar('Kata sandi berhasil diperbarui');
          Navigator.pop(context);
        } else {
          _showErrorSnackbar('Gagal memperbarui kata sandi');
        }
      } catch (e) {
        _showErrorSnackbar('Terjadi kesalahan: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
  }
}
