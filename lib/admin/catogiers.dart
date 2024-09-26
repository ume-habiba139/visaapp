import 'package:flutter/material.dart';
import 'package:visaapp/admin/home_screen.dart';
import 'package:visaapp/admin/listScreen.dart';

class VisaCategoriesList extends StatelessWidget {
  final List<String> visaCategories = [
    'Tourist Visa',
    'Business Visa',
    'Student Visa',
    'Work Visa',
    'Transit Visa',
    'Family Visa',
    'Diplomatic Visa',
    'Medical Visa',
    'Working Holiday Visa',
    'Permanent Resident Visa',
    'Religious Visa',
    'Investor Visa',
    'Refugee/Asylum Visa',
    'Cultural Exchange Visa',
    'Retirement Visa',
  ];

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

      body: ListView.builder(
        itemCount: visaCategories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.verified_user, color: Color.fromARGB(255, 101, 3, 5)),
              title: Text(
                visaCategories[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListHome(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
