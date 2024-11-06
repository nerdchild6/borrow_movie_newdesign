import 'package:borrow_movie/approver/app_home_screen.dart';
import 'package:borrow_movie/approver/app_main_screen.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';
import 'student/home_screen.dart'; // Import your home.dart
import 'student/borrow_screen.dart'; // Import your borrow_screen.dart
import 'student/status_screen.dart'; // Import your status_screen.dart
import 'student/history_screen.dart'; // Import your status_screen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Rental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE5DCC9),
      ),
      home: LoginScreen(), 
      debugShowCheckedModeBanner: false,// Set MainScreen as the home
    );
  }
}


