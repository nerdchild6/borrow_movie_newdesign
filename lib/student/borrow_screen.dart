import 'dart:async';
import 'dart:convert';

import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/borrow_details_screen.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final String url = '172.25.199.86:3000';
  bool isWaiting = false;
  List? movies;
  String? category = 'All';
  final List<String> categories = [
    'Adventure',
    'Action',
    'Comedy',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'War',
    'All'
  ];
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (data != null && data['categorie'] != null && category == 'All') {
      setState(() {
        category = data['categorie'];
      });
    }
  }

  Future<void> fetchMovies() async {
    setState(() => isWaiting = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      _navigateToLogin();
      return;
    }

    try {
      final jwt = JWT.decode(token);
      Uri uri = Uri.http(url, '/all_asset');
      final response =
          await http.get(uri, headers: {'authorization': token}).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        setState(() {
          movies = jsonDecode(response.body);
        });
      } else {
        _showDialog('Error', response.body);
      }
    } on TimeoutException {
      _showDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      _showDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() => isWaiting = false);
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

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(onPressed: _logout, child: const Text('Yes')),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _navigateToLogin();
  }

   void _navigateToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );

  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: const Color(0xFFE5DCC9),
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 10),
                Text('Header',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid() {
  if (isWaiting) {
    return const Center(child: CircularProgressIndicator());
  }
  if (movies == null) {
    return const Center(child: Text('No movies available'));
  }

  // Filter movies based on selected category
  final filteredMovies = category == 'All' 
    ? movies 
    : movies!.where((movie) => movie['categorie'] == category).toList();

  return GridView.builder(
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: filteredMovies?.length ?? 0,
    itemBuilder: (context, index) => _buildMovieCard(filteredMovies![index]),
  );
}

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    final statusColor = {
      'available': Colors.green,
      'pending': Colors.orange,
      'disabled': Colors.red,
      'borrowed': Colors.grey,
    }[movie['asset_status']] ?? Colors.black;

    return InkWell(
      onTap: () {
        if (movie['asset_status'] == 'available') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BorrowDetailsScreen(),
              settings: RouteSettings(arguments: {
                'image': movie['file_path'],
                'name': movie['asset_name'],
              }),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/images/movies/${movie['file_path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['asset_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${movie['asset_id']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      movie['asset_status'].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchAsset() async {
    setState(() {
      isWaiting = true;
    });
    try {
      Uri uri = Uri.http(url, '/asset', {'asset_name': search.text});
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        setState(() {
          movies = jsonDecode(response.body);
        });
      } else {
        _showDialog('Error', response.body);
      }
    } on TimeoutException catch (e) {
      debugPrint(e.message);
      _showDialog('Error', 'Timeout error, try again!');
    } catch (e) {
      debugPrint(e.toString());
      _showDialog('Error', 'Unknown error, try again!');
    } finally {
      setState(() {
        isWaiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'BORROW',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      endDrawer: _buildDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    hintText: 'Search movie name',
                    suffixIcon: IconButton(
                      onPressed: searchAsset,
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton<String>(
                  value: category,
                  items: categories.map((String cate) {
                    return DropdownMenuItem<String>(
                      value: cate,
                      child: Text(cate),
                    );
                  }).toList(),
                  onChanged: (String? newCategory) {
                    setState(() {
                      category = newCategory;
                    });
                    fetchMovies();
                  },
                ),
              ),
              Expanded(child: _buildMovieGrid()),
            ],
          ),
        ],
      ),
    );
  }
}
