import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:borrow_movie/login_student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRequestScreen extends StatefulWidget {
  const AppRequestScreen({super.key});

  @override
  State<AppRequestScreen> createState() => _AppRequestScreenState();
}

class _AppRequestScreenState extends State<AppRequestScreen> {
  List<dynamic> requests = []; // This will hold the request data

  @override
  void initState() {
    super.initState();
    fetchRequests(); // Fetch requests when the screen initializes
  }

  Future<void> fetchRequests() async {
    final response = await http.get(Uri.parse('http://192.168.1.8:3000/requests'));

    if (response.statusCode == 200) {
      setState(() {
        // Decode the response and filter for pending requests
        requests = json.decode(response.body)
            .where((request) => request['approve_status'] == 'pending')
            .toList();
      });
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    final response = await http.patch(
      Uri.parse('http://192.168.1.8:3000/api/requests/$requestId'), // API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'approve_status': status, // Update the field name to match your API
      }),
    );

    if (response.statusCode == 200) {
      // Request updated successfully, now fetch the requests again
      fetchRequests(); // Reload requests to refresh the list
    } else {
      throw Exception('Failed to update request status');
    }
  }

  void _showPopup(
    String movieName,
    String borrowerName,
    String borrowDate,
    String returnDate,
    dynamic requestId, // Change to dynamic if the type might be int
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color.fromARGB(255, 227, 226, 225),
          contentPadding: const EdgeInsets.all(15),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/john_wick.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Movie Name: $movieName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Borrower Name: $borrowerName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Borrow Date: $borrowDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Return Date: $returnDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      updateRequestStatus(requestId.toString(), 'rejected'); // Ensure requestId is a string
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      updateRequestStatus(requestId.toString(), 'approved'); // Ensure requestId is a string
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sure to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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

  void logout() async {
    // remove stored token
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await prefs.remove('token');


    // to prevent warning of using context in async function
    if (!mounted) return;
    // Cannot use only pushReplacement() because the dialog is showing
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

   // Method to create a drawer
  Widget createDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120, // Adjust the height to make it smaller
            decoration: const BoxDecoration(color: Color(0xFFE5DCC9)),
            padding: const EdgeInsets.all(8), // Add padding if needed
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      'Header',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ],
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFFD2C5B0),
      title: const Row(
        children: [
          Icon(Icons.playlist_add_check_circle_rounded, color: Colors.black),
          SizedBox(width: 8),
          Text('REQUEST', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Spacer(),
        ],
      ),
    ),
      endDrawer: createDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: requests.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: requests.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  var request = requests[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: const Color.fromARGB(255, 255, 181, 85),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Name: ${request['borrower_id']?.toString() ?? "Unknown"}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 71, 50, 5),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                color: Color.fromARGB(255, 255, 96, 17),
                                size: 40,
                              ),
                              onPressed: () {
                                _showPopup(
                                  'John Wick',
                                  request['borrower_id']?.toString() ?? "Unknown",
                                  request['borrow_date'] ?? "N/A",
                                  request['return_date'] ?? "N/A",
                                  request['request_id'].toString(), // Ensure this is a string
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
