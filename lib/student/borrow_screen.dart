import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/borrow_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final List<Map<String, dynamic>> movies = [
    {'title': 'John Wick', 'status': 'AVAILABLE', 'image': 'john_wick.png'},
    {'title': 'Venom 2', 'status': 'PENDING', 'image': 'venom_2.png'},
    {
      'title': 'Mission: Impossible 6',
      'status': 'DISABLE',
      'image': 'mission_impossible_6.png'
    },
    {
      'title': 'Fast and Furious 9',
      'status': 'AVAILABLE',
      'image': 'fast_and_furious_9.png'
    },
    {
      'title': 'The Amazing Spider-Man',
      'status': 'AVAILABLE',
      'image': 'amazing_spiderman.png'
    },
    {
      'title': 'Transformers',
      'status': 'BORROWED',
      'image': 'transformers.png'
    },
  ];

  String? category; // Nullable category
  final List<String> cate = [
    'Adventure',
    'Action',
    'Comedy',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'War',
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

  @override
  void initState() {
    super.initState();
    // Default category to a fallback value if no category is passed
    category = 'Adventure';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (data != null && data['categorie'] != null && category == 'Adventure') {
      // Set only if category is still at its initial default
      category = data['categorie'];
    }
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
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('BORROW', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
            Spacer(),
          ],
        ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search movie name',
                    prefixIcon: const Icon(Icons.search),
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
    items: cate.map((String cate) {
      return DropdownMenuItem<String>(
        value: cate,
        child: Text(
          cate,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Change the text color here
        ),
      );
    }).toList(),
    onChanged: (String? newValue) {
      setState(() {
        category = newValue!;
      });
    },
    dropdownColor: const Color.fromARGB(255, 235, 234, 233), // Set your desired dropdown background color here
    iconEnabledColor: const Color.fromARGB(255, 0, 0, 0), // Change icon color if needed
    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Change selected text color here
  ),
),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return _buildMovieCard(movies[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    Color statusColor;
    switch (movie['status']) {
      case 'AVAILABLE':
        statusColor = Colors.green;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      case 'DISABLE':
        statusColor = Colors.red;
        break;
      case 'BORROWED':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.black;
    }
   return InkWell(
      onTap: () {
        if(movie['status']=='AVAILABLE'){
          // Jump to the second route
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BorrowDetailsScreen(),
                settings: RouteSettings(
                  arguments: <String, dynamic>{
                    'image': '${movie['image']}',
                    'name': '${movie['title']}',
                  },
                ),
              ),
            );

        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/images/${movie['image']}',
              fit: BoxFit.fill,
              width: 117,
              height: 117,
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ID: 001',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      movie['status'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
}
