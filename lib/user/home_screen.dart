import 'package:flutter/material.dart';
import 'dart:io';
import 'package:visaapp/Database/database_helper.dart';
import 'package:visaapp/user/applyVisa.dart';
import 'package:visaapp/user/catogiers.dart';
import 'package:visaapp/user/checksection.dart';
import 'package:visaapp/user/listScreen.dart';
import 'package:visaapp/user/profile.dart';

void main() {
  runApp(Myhome1());
}

class Myhome1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _homeScreen(),
    );
  }
}

class _homeScreen extends StatefulWidget {
  const _homeScreen({super.key});

  @override
  State<_homeScreen> createState() => __homeScreenState();
}

class __homeScreenState extends State<_homeScreen> {
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
              MaterialPageRoute(builder: (context) => Myhome1()),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 229, 226, 229),
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
                          'For short-term visits up to 90 days.',
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
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 180),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ApplyVisaScreen(visaTitle: '',)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 145, 3, 53),
                              side: BorderSide(color: Colors.white),
                            ),
                            child: const Text('Apply Now',style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
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
            IconButton(
              icon: const Icon(Icons.checklist_rounded, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>VisaInfoListScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ProfileScreen ()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
