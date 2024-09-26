import 'dart:io';
import 'package:flutter/material.dart';
import 'package:visaapp/Database/database_helper.dart';
import 'package:visaapp/admin/home_screen.dart';
import 'package:visaapp/admin/updatevisa.dart';

void main() {
  runApp(ListHome());
}

class ListHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _ListScreen(),
    );
  }
}

class _ListScreen extends StatefulWidget {
  const _ListScreen({super.key});

  @override
  State<_ListScreen> createState() => __ListScreenState();
}

class __ListScreenState extends State<_ListScreen> {
  // This function fetches visa posts and updates the UI.
  Future<void> _refreshList() async {
    setState(() {});
  }

  void _confirmDelete(BuildContext context, int? visaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteVisa(visaId); // Call the delete function with ID
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToUpdateScreen(VisaInfo visaInfo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateVisaInfoScreen(visaInfo: visaInfo),
      ),
    );

    if (result == true) {
      _refreshList(); // Refresh the list after updating
    }
  }

  void _deleteVisa(int? visaId) async {
    if (visaId == null) return;

    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'visa_info',
      where: 'id = ?', // Delete by unique ID
      whereArgs: [visaId],
    );

    _refreshList(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Applications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 145, 3, 53),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyhomeAD()),
            );
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 229, 226, 229),
      body: FutureBuilder<List<VisaInfo>>(
        future: DatabaseHelper.instance.getVisaInfoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final visaInfoList = snapshot.data!;

            if (visaInfoList.isEmpty) {
              return Center(child: Text('No visa information available.'));
            }

            return ListView.builder(
              itemCount: visaInfoList.length,
              itemBuilder: (context, index) {
                final visa = visaInfoList[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              visa.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'visaType: ${visa.visaType}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Issuing Authority: ${visa.authority}',
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${visa.description}',
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Apply before: ${visa.expirationDate}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 145, 3, 53),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        visa.imagePath != null
                            ? Image.file(
                          File(visa.imagePath!),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : const Text("No image available"),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _navigateToUpdateScreen(visa);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 145, 3, 53),
                                side: BorderSide(color: Colors.white),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _confirmDelete(context, visa.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 145, 3, 53),
                                side: BorderSide(color: Colors.white),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
