import 'package:flutter/material.dart';
import 'package:visaapp/Database/database_helper.dart';
import 'package:visaapp/admin/catogiers.dart';
import 'package:visaapp/admin/upload.dart';

void main() {
  runApp(MyhomeAD());
}

class MyhomeAD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: const Color.fromARGB(255, 145, 3, 53),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 229, 226, 229),
      body: FutureBuilder<List<ApplyVisa>>(
        future: DatabaseHelper.instance.getapplyVisaInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final visaApplications = snapshot.data!;
            print('Visa Info List: $visaApplications');
            if (visaApplications.isEmpty) {
              return Center(child: const Text('No visa information available.'));
            }

            return ListView.builder(
              itemCount: visaApplications.length,
              itemBuilder: (context, index) {
                final visa = visaApplications[index];

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
                            const Icon(Icons.person, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              visa.fullName, // Full name of the applicant
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.description, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Visa Type: ${visa.visaType}', // Visa type applied for
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              'Applied on: ${visa.fullName}', // Application date
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Status: ${visa.visaType}', // Visa application status
                              style: TextStyle(
                                color: Colors.grey[700],
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
      bottomNavigationBar: BottomAppBar(
        height: 62,
        color: const Color.fromARGB(255, 145, 3, 53),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: () {
                // Home button action
              },
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadVisaInfoApp()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.category, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisaCategoriesList()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
