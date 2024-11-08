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
  String? userId;

  // Fetch movie data using assetId from the route arguments
  Future<void> fetchMovies(String assetId) async {
    setState(() => isWaiting = true);

    try {
      final token = await _getToken();
      if (token == null) return _navigateToLogin();

      final jwt = JWT.decode(token);
      userId = jwt.payload['user_id'].toString();

      final response = await http
          .get(Uri.http(_url, '/asset/asset_id/$assetId'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() => movies = jsonDecode(response.body));
      } else {
        debugPrint('Failed to fetch movie data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Error fetching movie data: $e');
    } finally {
      setState(() => isWaiting = false);
    }
  }

  // Retrieve token from local storage
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Borrow movie function
  Future<void> borrow(String assetId) async {
    setState(() => isWaiting = true);

    try {
      final token = await _getToken();
      if (token == null) return _navigateToLogin();

      final jwt = JWT.decode(token);
      final userId = jwt.payload['user_id'].toString();

      final response = await http
          .post(
            Uri.http(_url, '/borrow'),
            body: {'asset_id': assetId, 'user_id': userId},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if(response.body == 'can borrow only one movie per day'){
          _showDialog('Can not borrow', response.body);
        }else{
        _showDialog('Borrow Successful', response.body);
        }
        

      } else {
        _showDialog('Error', 'Failed to borrow. Please try again.');
      }
    } on TimeoutException {
      debugPrint('Request timed out. Please try again.');
      _showDialog('Error', 'Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Error: $e');
      _showDialog('Error', 'An error occurred. Please try again.');
    } finally {
      setState(() => isWaiting = false);
    }
  }

  // Show dialog with the result message
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => {
              if(title == 'Borrow Successful'){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const StatusScreen()),
          )}else{Navigator.pop(context)}
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Navigate to login screen if token is null
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
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final assetId = args['asset_id'].toString();
      fetchMovies(assetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final assetId = args['asset_id'].toString();
    final today = DateTime.now();
    final returnDate = today.add(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: Row(
          children: const [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('BORROW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
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
                        'Return Date : ${returnDate.day}/${returnDate.month}/${returnDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 88, 88, 88),
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text('Back', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: movies == null || isWaiting ? null : () => {
                              borrow(assetId)
                              
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
