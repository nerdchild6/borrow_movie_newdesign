import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final String url = '172.25.199.86:3000';
  bool isWaiting = false;
  String username = '';
  String userId = '';
  List<dynamic>? historyData;

  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  Future<void> popDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getExpenses() async {
    setState(() {
      isWaiting = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final jwt = JWT.decode(token);
      final payload = jwt.payload;
      username = payload['username'] ?? '';
      userId = payload['user_id']?.toString() ?? '';

      final uri = Uri.http(url, '/history/$userId');
      final response = await http.get(uri, headers: {'Authorization': token}).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        setState(() {
          historyData = jsonDecode(response.body);
          debugPrint('expense : $historyData');
          debugPrint('payload : $payload');
        });
      } else {
        await popDialog('Error', response.body);
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      await popDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      debugPrint(e.toString());
      await popDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
  }

  Future<void> confirmLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sure to logout?'),
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

  Widget createDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: const Color(0xFFE5DCC9),
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
            child: Center(
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
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format dates
    String formatDate(String dateStr) {
      final date = DateTime.parse(dateStr);
      return DateFormat('d/M/yyyy').format(date);
    }
    return Scaffold(
      backgroundColor: const Color(0xFFE5DCC9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.history, color: Colors.black),
            SizedBox(width: 8),
            Text('HISTORY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color.fromARGB(255, 75, 75, 75)),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: createDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: historyData == null
              ? Center(child: isWaiting ? CircularProgressIndicator() : const Text('No history found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: historyData!.length,
                  itemBuilder: (context, index) {
                    final data = historyData![index];
                    final statusColor = _getStatusColor(data['approve_status'] ?? '');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/movies/${data['file_path'] ?? ''}',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data['asset_name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text('Borrow Date : ${formatDate(data['borrow_date'])}', style: const TextStyle(fontSize: 11)),
                                      const SizedBox(height: 8),
                                      Text('Return Date : ${formatDate(data['return_date'])}', style: const TextStyle(fontSize: 11)),
                                      const SizedBox(height: 8),
                                      Text('Approver Name : ${data['approver_name'] ?? ''}', style: const TextStyle(fontSize: 11)),
                                      const SizedBox(height: 8),
                                      Text('Recipient of returned : ${data['admin_name'] ?? ''}', style: const TextStyle(fontSize: 11)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text('Status : ', style: TextStyle(fontSize: 11)),
                                          Text(
                                            data['approve_status'] ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
