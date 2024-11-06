import 'package:borrow_movie/admin/Ad_borrow_screen.dart';
import 'package:borrow_movie/login_student.dart';
import 'package:flutter/material.dart';

class AdHomeScreen extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: Row(
          children: [
            const Icon(Icons.home, color: Colors.black),
            const SizedBox(width: 8),
            const Text('HOME', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            Expanded(child: Container()),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: createDrawer(context),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Path to your background image
              fit: BoxFit.cover, // Scale the image to cover the entire area
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: [
                    'Adventure',
                    'Action',
                    'Comedy',
                    'Fantasy',
                    'Horror',
                    'Romance',
                    'Sci-Fi',
                    'Thriller',
                    'War'
                  ].map((genre) => _buildCategoryItem(genre, context)).toList(),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Recommended',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildRecommendedItem('recommended1.png'),
                      _buildRecommendedItem('recommended2.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String genre, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdBorrowScreen(),
            settings: RouteSettings(
              arguments: <String, dynamic>{
                'categorie': genre,
              },
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$genre.png',
              width: 83,
              height: 83,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey,
                  child: const Center(child: Text('No Image')),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(genre),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedItem(String imageName) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Image.asset(
        'assets/images/$imageName',
        width: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 250,
            color: Colors.grey,
            child: const Center(child: Text('No Image')),
          );
        },
      ),
    );
  }
}
