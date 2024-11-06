import 'package:borrow_movie/student/status_screen.dart';
import 'package:flutter/material.dart';

class BorrowDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetching data passed through route arguments
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Setting up borrow and return dates
    final DateTime _today = DateTime.now();
    final DateTime _returnDate = _today.add(const Duration(days: 7));

    // Formatting return date
    final int _returnDay = _returnDate.day;
    final int _returnMonth = _returnDate.month;
    final int _returnYear = _returnDate.year;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2C5B0),
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text('BORROW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content with white box
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage('assets/images/${data['image']}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Name : ${data['name']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Borrow Date : ${_today.day}/${_today.month}/${_today.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Return Date : $_returnDay/$_returnMonth/$_returnYear',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 88, 88, 88),
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text('Back', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatusScreen(),
                                  settings: RouteSettings(
                                    arguments: <String, dynamic>{
                                      'mo_name': data['name'],
                                      'borrow_date': '${_today.day}/${_today.month}/${_today.year}',
                                      'return_date': '$_returnDay/$_returnMonth/$_returnYear',
                                      'bor_name': 'John', // Change to dynamic if necessary
                                      'status': 'Pending',
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text('Borrow', style: TextStyle(color: Colors.white)),
                          ),

                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
