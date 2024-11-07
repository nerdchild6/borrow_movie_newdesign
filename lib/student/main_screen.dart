import 'package:borrow_movie/student/borrow_screen.dart';
import 'package:borrow_movie/student/history_screen.dart';
import 'package:borrow_movie/student/home_screen.dart';
import 'package:borrow_movie/student/status_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    BorrowScreen(),
    StatusScreen(),
    HistoryScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: 'Borrow'),
          BottomNavigationBarItem(icon: Icon(Icons.list, size:30), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: 30), label: 'History'), // Profile tab if needed
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

