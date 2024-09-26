
import 'package:flutter/material.dart';
import 'package:visaapp/user/home_screen.dart';
void main() {
  runApp(listhome());
}

class listhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _listScreen(),
    );
  }
}

class _listScreen extends StatefulWidget {
  const _listScreen({super.key});

  @override
  State<_listScreen> createState() => __listScreenState();
}

class __listScreenState extends State<_listScreen> {
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
        backgroundColor: Color.fromARGB(255, 229, 226, 229),
        body:  SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Container(
                height: 403,
                width: 400,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: Colors.blueAccent, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Tourist Visa - USA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'For short-term visits up to 90 days.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Issuing Authority: Pakistan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Apply before: 31st December 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 145, 3, 53),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7,),
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Dubai_Skylines_at_night_%28Pexels_3787839%29.jpg/640px-Dubai_Skylines_at_night_%28Pexels_3787839%29.jpg',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 165),
                      child: ElevatedButton(
                        onPressed: ()
                        {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 145, 3, 53), // Set the background color
                          side: BorderSide(color: Colors.white), // Set the border color
                        ),
                        child: Text('Apply Now',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold),),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
