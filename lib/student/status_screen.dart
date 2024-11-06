import 'package:flutter/material.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/main_screen.dart';

class StatusScreen extends StatelessWidget {
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
                onPressed: () {
                  // Simulate successful login and navigate to HomeScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label:
                    const Text('Logout', style: TextStyle(color: Colors.white)),
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
    // Retrieve the data from the route arguments
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.black),
            SizedBox(width: 8),
            Text('STATUS', style: TextStyle(color: Colors.black , fontWeight:FontWeight.bold)),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: createDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: data != null && data.isNotEmpty
            ? DefaultTabController(
                length: 1, // Only one tab is being used
                child: Column(
                  children: [
                    _buildStatusTab(data),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (Route<dynamic> route) => false, // Remove all previous routes
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 229, 229, 229), // Background color
                        foregroundColor: Colors.black, // Text color
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0), // Padding
                        elevation: 5, // Elevation
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Border radius
                        ),
                      ),
                      child: const Text('Home'),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text('No data available.', style: TextStyle(fontSize: 18)),
              ),
      ),
    );
  }

  Widget _buildStatusTab(Map<String, dynamic> data) {
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
                Text('Movie name: ${data['mo_name']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Borrow date: ${data['borrow_date']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Return date: ${data['return_date']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Borrower name: ${data['bor_name']}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontSize: 16)),
                    Text(
                      data['status'] ?? 'Pending',
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