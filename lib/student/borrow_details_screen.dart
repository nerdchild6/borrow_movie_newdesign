import 'dart:async';
import 'dart:convert';

import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/status_screen.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BorrowDetailsScreen extends StatefulWidget {
  const BorrowDetailsScreen({super.key});

  @override
  State<BorrowDetailsScreen> createState() => _BorrowDetailsScreenState();
}

class _BorrowDetailsScreenState extends State<BorrowDetailsScreen> {
  final String _url = '172.25.199.86:3000';
  bool isWaiting = false;
  List? movies;

  // Fetch movie data using the asset_id from the passed parameter
  Future<void> fetchMovies(String assetId) async {
    setState(() => isWaiting = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _navigateToLogin();
      return;
    }

    try {
      final jwt = JWT.decode(token);
      // Use the asset_id passed as parameter
      Uri uri = Uri.http(_url, '/asset/asset_id/$assetId');
      http.Response response = await http.get(uri).timeout(const Duration(seconds: 5));      
      if (response.statusCode == 200) {
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        try {
          final data = jsonDecode(response.body); // Attempt to parse JSON
          setState(() {
            movies = data; // Update the movies list
          });
        } catch (e) {
          // If jsonDecode fails, handle as plain text
          debugPrint('Response body not JSON');
        }
      } else {
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Your navigation or context-dependent code here
    final Map<String, dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String assetId = data['asset_id'].toString();
    fetchMovies(assetId); // Fetch data after the widget is initialized
  });
}


  @override
  Widget build(BuildContext context) {
    // Fetching data passed through route arguments
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    debugPrint('$data');
    // Extracting asset_id from route arguments
    final String assetId = data['asset_id'].toString();
    debugPrint('assetId : $assetId');

    // Setting up borrow and return dates
    final DateTime today = DateTime.now();
    final DateTime returnDate = today.add(const Duration(days: 7));

    // Formatting return date
    final int returnDay = returnDate.day;
    final int returnMonth = returnDate.month;
    final int returnYear = returnDate.year;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('BORROW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content with white box
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (movies != null && movies!.isNotEmpty)
                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/images/movies/${movies![0]['file_path']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (movies != null && movies!.isNotEmpty)
                        Text(
                          'Name : ${movies![0]['asset_name']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Borrow Date : ${today.day}/${today.month}/${today.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Return Date : $returnDay/$returnMonth/$returnYear',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 88, 88, 88),
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text('Back', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: movies == null || isWaiting ? null : () {
                              // Borrow action if movies are fetched and no ongoing request
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text('Borrow', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
