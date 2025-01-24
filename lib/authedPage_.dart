import 'package:emisi_md/Pages/Home.dart';
import 'package:emisi_md/Pages/article.dart';  // Pastikan path dan nama file sudah benar
import 'package:emisi_md/profilePage_.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthedPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const AuthedPage({required this.userId, required this.userData, Key? key}) : super(key: key);

  @override
  _AuthedPageState createState() => _AuthedPageState();
}

class _AuthedPageState extends State<AuthedPage> {
  int _selectedIndex = 0; // Default to Home Page

  // List of pages (Home and Article)
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userId: widget.userId), // Home page
      ArticlePage(), // Artikel page (No need for userData if not required)
    ];
  }

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selamat Datang',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          // Profile button action: Navigate to Profile Page
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // When Profile is tapped, you can navigate to Profile Page
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
      body: _pages[_selectedIndex], // Display current page based on selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Change the current page when tapping a bottom nav item
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedFontSize: 16,
        unselectedFontSize: 14,
      ),
    );
  }
}
