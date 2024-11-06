import 'package:borrow_movie/approver/app_borrow_screen.dart';
import 'package:borrow_movie/approver/app_dashboard_screen.dart';
import 'package:borrow_movie/approver/app_history_screen.dart';
import 'package:borrow_movie/approver/app_home_screen.dart';
import 'package:borrow_movie/approver/app_request_screen.dart';
import 'package:flutter/material.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AppHomeScreen(),
    AppBorrowScreen(),
    AppDashboardScreen(),
    AppRequestScreen(),
    AppHistoryScreen(),
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
        backgroundColor: Color.fromARGB(255, 161, 149, 127),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: 'Borrow'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard, size: 30), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check_circle_rounded, size: 30), label: 'Request'),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: 30), label: 'History'), // Profile tab if needed
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}