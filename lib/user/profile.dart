import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visaapp/Database/database_helper.dart';
import 'package:visaapp/user/editScreen.dart';
import 'package:visaapp/user/notification.dart';  // Import SharedPreferences

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('loggedInUserEmail'); // Get the logged-in user's email

    if (email != null) {
      final dbHelper = DatabaseHelper.instance;
      final userData = await dbHelper.getUserByEmail(email);

      if (userData != null) {
        setState(() {
          _user = User(
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            email: userData['email'],
            password: userData['password'],
            confirmPassword: userData['confirmPassword'],
            age: userData['age'],
            gender: userData['gender'],
          );
        });
      } else {
        print("No user data found for the email: $email");
      }
    } else {
      print("No logged-in user email found in SharedPreferences");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Visa App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 145, 3, 53),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white), // Notification icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SimpleNotificationScreen ()),
              );
            },
          ),
        ],
      ),


      backgroundColor: Color.fromARGB(255, 229, 226, 229),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Profile picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=2048x2048&w=is&k=20&c=6hQNACQQjktni8CxSS_QSPqJv2tycskYmpFGzxv3FNs=",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_user?.firstName} ${_user?.lastName}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${_user?.email}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 145, 3, 53),),
            ),
            SizedBox(height: 10),
            _buildInfoCard('Full Name', '${_user?.firstName} ${_user?.lastName}', Icons.account_circle),
            _buildInfoCard('Email', '${_user?.email}', Icons.email),
            _buildInfoCard('Age', '${_user?.age}', Icons.cake),
            _buildInfoCard('Gender', '${_user?.gender}', Icons.person),
            SizedBox(height: 20),

// Passport Information Section
            Text(
              'Passport Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color:   Color.fromARGB(255, 145, 3, 53),),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment_ind, color:Color.fromARGB(255, 145, 3, 53),),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Passport Number', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('A1234567', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color:Color.fromARGB(255, 145, 3, 53),),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Passport Expiry Date', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('December 31, 2025', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

// Account Settings Section
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color:   Color.fromARGB(255, 145, 3, 53),),
            ),
            SizedBox(height: 10),

            GestureDetector(
              onTap: () {
// Navigate to edit profile screen
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Editprofile()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.settings, color:Color.fromARGB(255, 145, 3, 53),),
                      SizedBox(width: 10),
                      Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
// Navigate to change password screen
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, color:Color.fromARGB(255, 145, 3, 53),),
                    SizedBox(width: 10),
                    Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
// Handle logout
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color:Color.fromARGB(255, 145, 3, 53),),
                    SizedBox(width: 10),
                    Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 145, 3, 53)),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }
}
