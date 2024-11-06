
import 'package:borrow_movie/login_student.dart';
import 'package:borrow_movie/student/borrow_details_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdBorrowScreen extends StatefulWidget {
  @override
  State<AdBorrowScreen> createState() => _AdBorrowScreenState();
}

class _AdBorrowScreenState extends State<AdBorrowScreen> {
  File? _imageFileAdd;
  File? _imageFileEdit;
  final List<Map<String, dynamic>> movies = [
    {
      'title': 'John Wick',
      'status': 'AVAILABLE',
      'image': 'john_wick.png',
      'sw': false,
      'catego': 'Action'
    },
    {
      'title': 'Venom 2',
      'status': 'PENDING',
      'image': 'venom_2.png',
      'sw': false,
      'catego': 'Action'
    },
    {
      'title': 'Mission: Impossible 6',
      'status': 'DISABLE',
      'image': 'mission_impossible_6.png',
      'sw': false,
      'catego': 'Action'
    },
    {
      'title': 'Fast and Furious 9',
      'status': 'AVAILABLE',
      'image': 'fast_and_furious_9.png',
      'sw': false,
      'catego': 'Action'
    },
    {
      'title': 'The Amazing Spider-Man',
      'status': 'AVAILABLE',
      'image': 'amazing_spiderman.png',
      'sw': false,
      'catego': 'Action'
    },
    {
      'title': 'Transformers',
      'status': 'BORROWED',
      'image': 'transformers.png',
      'sw': false,
      'catego': 'Action'
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

  @override
  void initState() {
    super.initState();
    category = 'Adventure'; // Set default category
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (data != null && data['categorie'] != null && category == 'Adventure') {
      category = data['categorie'];
    }
  }

  Future<void> _pickImageAdd() async {
    final pickedFileAdd =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFileAdd != null) {
        _imageFileAdd = File(pickedFileAdd.path);
      }
    });
  }

  Future<void> _pickImageEdit() async {
    final pickedFileEdit =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFileEdit != null) {
        _imageFileEdit = File(pickedFileEdit.path);
      }
    });
  }

  // Update toggleSwitch to change the switch status of an individual movie
  void toggleSwitch(int index, bool status) {
    setState(() {
      movies[index]['sw'] = status;
      if (movies[index]['sw']) {
        if (movies[index]['status'] == "AVAILABLE") {
          movies[index]['status'] = "DISABLE";
        }
      } else {
        if (movies[index]['status'] == "DISABLE") {
          movies[index]['status'] = "AVAILABLE";
        }
      }
    });
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

  void showEditDialog(int index) async {
    // Set initial values for each movie's fields
    String currentCategory = movies[index]['catego'];
    TextEditingController titleController =
        TextEditingController(text: movies[index]['title']);

    String imagePath = 'assets/images/${movies[index]['image']}';

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Details'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageFileEdit == null
                      ? GestureDetector(
                          onTap: () async {
                            await _pickImageEdit();
                            setDialogState(() {}); // Rebuild to show new image
                          },
                          child: Image.asset(
                            imagePath,
                            height: 200, // Set desired height
                            width: 200, // Set desired width
                            fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            await _pickImageEdit();
                            setDialogState(() {}); // Rebuild to show new image
                          },
                          child: Image.file(
                            _imageFileEdit!,
                            height: 200, // Set desired height
                            width: 200, // Set desired width
                            fit: BoxFit.cover,
                          ),
                        ),
                  DropdownButton<String>(
                    value: currentCategory,
                    items: cate.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        currentCategory = newValue!;
                      });
                    },
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  movies[index]['catego'] = currentCategory;
                  movies[index]['title'] = titleController.text;
                  if (_imageFileEdit != null) {
                    movies[index]['image'] =
                        _imageFileEdit!.path.split('/').last;
                  }
                });
                Navigator.of(context).pop('Confirm');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showAddDialog() async {
    // Set initial values for each movie's fields
    // String currentCategory = movies[index]['catego'];
    // TextEditingController titleController = TextEditingController(text: movies[index]['title']);
    String currentCategory = "Adventure";
    // String imagePath = 'assets/images/${movies[index]['image']}';

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Details'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageFileAdd == null
                      ? ElevatedButton(
                          onPressed: () async {
                            await _pickImageAdd();
                            setDialogState(() {}); // Rebuild to show new image
                          },
                          child: const Text('Pick Image'),
                        )
                      : GestureDetector(
                          onTap: () async {
                            await _pickImageAdd();
                            setDialogState(() {}); // Rebuild to show new image
                          },
                          child: Image.file(
                            _imageFileAdd!,
                            height: 180, // Set desired height
                            width: 180, // Set desired width
                            fit: BoxFit.cover,
                          ),
                        ),
                  DropdownButton<String>(
                    value: currentCategory,
                    items: cate.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        currentCategory = newValue!;
                      });
                    },
                  ),
                  const TextField(
                    // controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Cancel');
                _imageFileAdd = null;
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _imageFileAdd = null;
                });
                // setState(() {
                //   movies[index]['catego'] = currentCategory;
                //   movies[index]['title'] = titleController.text;
                //   if (_imageFile != null) {
                //     movies[index]['image'] = _imageFile!.path.split('/').last;
                //   }
                // });
                Navigator.of(context).pop('Confirm');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5DCC9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('BORROW', style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold)),
            Spacer(),
          ],
        ),
      ),
      endDrawer: createDrawer(context),
      body: Container( decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
    dropdownColor: Color.fromARGB(255, 235, 234, 233), // Set your desired dropdown background color here
    iconEnabledColor: Color.fromARGB(255, 0, 0, 0), // Change icon color if needed
    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Change selected text color here
  ),
),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return _buildMovieCard(movies[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie, int index) {
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

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/images/${movie['image']}',
              fit: BoxFit.fill,
              width: 130,
              height: 130,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              movie['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              // maxLines: 2,
              // overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 9),
                    const Text(
                      'ID: 001',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 20, width: 80),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        movie['status'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Change to spaceBetween
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: movie['status'] == "AVAILABLE"
                            ? false
                            : movie['status'] == "DISABLE"
                                ? true
                                : false,
                        onChanged: (status) => toggleSwitch(index, status),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () => showEditDialog(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(fontSize: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('EDIT',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
