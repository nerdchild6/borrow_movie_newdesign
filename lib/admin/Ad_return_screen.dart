
import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdReturnScreen extends StatefulWidget {
  const AdReturnScreen({super.key});

  @override
  State<AdReturnScreen> createState() => _AdReturnScreenState();
}

class _AdReturnScreenState extends State<AdReturnScreen> {
  final List<String> names = [
    'Somsak Jaidee',
    'Student 1',
    'Student 2',
    'Student 3',
    'Student 4',
    'Student 5',
    'Student 6',
    'Student 7',
    'Student 8',
    'Student 9',
    'Student 10',
  ];

  // Current selected index in the list (if any)
  final int _selectedIndex = 0;

  // Method to show a pop-up with return details
  void _showPopup(
    String movieName,
    String borrowerName,
    String borrowDate,
    String returnDate,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromARGB(255, 227, 226, 225),
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
                borderRadius: BorderRadius.circular(20), // Rounded corners
                child: Image.asset(
                  'assets/images/john_wick.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover, // Cover entire area
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
              // Display borrower details with white background
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
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Back',
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
                      // Add return logic here
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Return',
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
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFFD2C5B0),
      title: const Row(
        children: [
          Icon(Icons.playlist_add_check_circle_rounded, color: Colors.black),
          SizedBox(width: 8),
          Text('RETURN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
        child: ListView.builder(
          itemCount: names.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
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
                          'Name: ${names[index]}',
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
                            names[index],
                            '20/10/2024',
                            '25/10/2024',
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
