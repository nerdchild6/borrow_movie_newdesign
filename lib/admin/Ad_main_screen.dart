import 'package:borrow_movie/admin/Ad_borrow_screen.dart';
import 'package:borrow_movie/admin/Ad_dashboard_screen.dart';
import 'package:borrow_movie/admin/Ad_history_screen.dart';
import 'package:borrow_movie/admin/Ad_home_screen.dart';
import 'package:borrow_movie/admin/Ad_return_screen.dart';
import 'package:borrow_movie/student/borrow_screen.dart';
import 'package:borrow_movie/student/history_screen.dart';
import 'package:borrow_movie/student/home_screen.dart';
import 'package:borrow_movie/student/status_screen.dart';
import 'package:flutter/material.dart';

class AdMainScreen extends StatefulWidget {
  const AdMainScreen({super.key});

  @override
  _AdMainScreenState createState() => _AdMainScreenState();
}

class _AdMainScreenState extends State<AdMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdHomeScreen(),
    AdBorrowScreen(),
    const AdDashboardScreen(),
    const AdReturnScreen(),
    AdHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show the current screen
      bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 161, 149, 127),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: 'Borrow'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: 30), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check_circle_rounded, size: 30), label: 'Return'),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: 30), label: 'History'), // Profile tab if needed
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}