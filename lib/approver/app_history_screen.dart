import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHistoryScreen extends StatefulWidget {
  const AppHistoryScreen({super.key});

  @override
  State<AppHistoryScreen> createState() => _AppHistoryScreenState();
}

class _AppHistoryScreenState extends State<AppHistoryScreen> {
  final List<Map<String, String>> historyData = [
    {
      'title': 'Harry Potter',
      'image': 'assets/images/Fantasy.png',
      'borrowName': 'John',
      'borrowDate': '19/10/2024',
      'returnDate': '26/10/2024',
      'recipient': 'Admin 1',
      'status': 'Approved',
    },
    {
      'title': 'Harry Potter',
      'image': 'assets/images/Fantasy.png',
      'borrowName': 'John',
      'borrowDate': '19/10/2024',
      'returnDate': '26/10/2024',
      'recipient': 'Admin 1',
      'status': 'Approved',
    },
    {
      'title': 'Harry Potter',
      'image': 'assets/images/Fantasy.png',
      'borrowName': 'John',
      'borrowDate': '19/10/2024',
      'returnDate': '26/10/2024',
      'recipient': 'Admin 1',
      'status': 'Disapproved',
    },
    {
      'title': 'Harry Potter',
      'image': 'assets/images/Fantasy.png',
      'borrowName': 'John',
      'borrowDate': '19/10/2024',
      'returnDate': '26/10/2024',
      'recipient': 'Admin 1',
      'status': 'Approved',
    },
  ];

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
            height: 120,
            decoration: const BoxDecoration(color: Color(0xFFE5DCC9)),
            padding: const EdgeInsets.all(8),
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

  // Helper function to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Disapproved':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      endDrawer: createDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              final data = historyData[index];
              final statusColor = _getStatusColor(data['status']!);
              
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
                        color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Horizontal and vertical offset
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              data['image']!,
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Details section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 const SizedBox(height: 16),
                                Text('Borrower Name : ${data['borrowName']}',
                                    style: const TextStyle(fontSize: 11)),
                                const SizedBox(height: 8),
                                Text('Borrow Date : ${data['borrowDate']}',
                                    style: const TextStyle(fontSize: 11)),
                                const SizedBox(height: 8),
                                Text('Return Date : ${data['returnDate']}',
                                    style: const TextStyle(fontSize: 11)),
                               
                                const SizedBox(height: 8),
                                Text('Recipient of returned : ${data['recipient']}',
                                    style: const TextStyle(fontSize: 11)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Status : ',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    Text(
                                      data['status']!,
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