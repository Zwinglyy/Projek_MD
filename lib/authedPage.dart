import 'package:flutter/material.dart';

//import 'package:emisi_md/dashboardPage.dart';


class AuthedPage extends StatefulWidget {
  final String userName;
  final Map<String, dynamic> userData;
  AuthedPage({required this.userName, required this.userData});

  @override
  _AuthedPageState createState() => _AuthedPageState();
}

class _AuthedPageState extends State<AuthedPage> {
  int _selectedIndex = 1; // Default to Dashboard
  
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize _pages here using widget.userName
    _pages = [
    //  ExpenseScreen(userName: widget.userName),
    //  DashboardScreen(userId: widget.userName, userData: widget.userData,),
    //  IncomeScreen(userName: widget.userName), // Corrected: use widget.userName
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, ${widget.userName}'), // Showing the logged-in user
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Pengeluaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dasbor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Pendapatan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
