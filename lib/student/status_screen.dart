import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final String url = '172.25.199.86:3000';
  bool isWaiting = false;
  List<dynamic>? request;
  String? userId;
  String username = '';

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: logout,
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(color: Color(0xFFE5DCC9)),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.black),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: confirmLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchExpenses() async {
    setState(() => isWaiting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      // Decode JWT to get username and role
      final jwt = JWT.decode(token);
      userId = jwt.payload['user_id'].toString();
      username = jwt.payload['username'] ?? '';

      Uri uri = Uri.http(url, '/request/$userId');
      http.Response response = await http.get(
        uri,
        headers: {'authorization': token},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          request = jsonDecode(response.body);
        });
        debugPrint('Request: $request');
      } else {
        showErrorDialog('Error', response.body);
      }
    } on TimeoutException {
      showErrorDialog('Error', 'Request timed out. Please try again.');
    } catch (e) {
      showErrorDialog('Error', 'An unknown error occurred.');
    } finally {
      setState(() => isWaiting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black),
            SizedBox(width: 8),
            Text('STATUS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: request != null && request!.isNotEmpty
            ? Column(
                children: [
                  buildStatusCard(request![0]),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('Home'),
                  ),
                ],
              )
            : const Center(
                child: Text('No data available.', style: TextStyle(fontSize: 18)),
              ),
      ),
    );
  }

  Widget buildStatusCard(Map<String, dynamic> data) {
    // Format dates
    String formatDate(String dateStr) {
      final date = DateTime.parse(dateStr);
      return DateFormat('d/M/yyyy').format(date);
    }

    return SingleChildScrollView(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Movie name: ${data['asset_name']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Borrow date: ${formatDate(data['borrow_date'])}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Return date: ${formatDate(data['return_date'])}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Borrower name: ${data['user_name']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontSize: 16)),
                    Text(
                      '${data['approve_status']}',
                      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 186, 113, 11)),
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
}
