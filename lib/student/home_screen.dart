import 'dart:async';
import 'dart:convert';

import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/borrow_screen.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String url = '172.25.199.86:3000';
  bool isWaiting = false;
  String username = '';
  List? asset;

  void popDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  void getExpenses() async {
    setState(() {
      isWaiting = true;
    });
    try {
      // get JWT token from local storage
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');


      if (token == null) {
        // no token, jump to login page
        // check mounted to use 'context' for navigation in 'async' method
        if (!mounted) return;
        // Cannot use only pushReplacement() because the dialog is showing
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }


      // token found
      // decode JWT to get uername and role
      final jwt = JWT.decode(token!);
      Map payload = jwt.payload;


      // get expenses
      Uri uri = Uri.http(url, '/all_asset');
      http.Response response =
          await http.get(uri, headers: {'authorization': token}).timeout(
        const Duration(seconds: 10),
      );
      // check server's response
      if (response.statusCode == 200) {
        // show expenses in ListView
        setState(() {
          // update username
          // username = payload['username'];
          // convert response to List
          asset = jsonDecode(response.body);
    debugPrint('expense : $asset');

        });
      } else {
        // wrong username or password
        popDialog('Error', response.body);
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      popDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      debugPrint(e.toString());
      popDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
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
  void initState() {
    super.initState();
    getExpenses();
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
            const Text('HOME', style: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold)),
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
  // Find the first asset with a matching category.
  var matchingAsset = asset?.firstWhere(
    (item) => item['asset_name'] == genre,
    orElse: () => null,
  );

  String filePath = matchingAsset != null
      ? 'assets/images/categories/${matchingAsset['asset_name']}.png'
      : 'assets/images/categories/$genre.png'; // Default if not found

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BorrowScreen(),
          settings: RouteSettings(
  arguments: <String, dynamic>{
    'categorie': matchingAsset?['asset_name'] ?? genre,
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
            filePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
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
        'assets/images/categories/$imageName',
        width: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}
