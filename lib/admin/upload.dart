import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visaapp/admin/home_screen.dart';
import '../Database/database_helper.dart';

void main() {
  runApp(UploadVisaInfoApp());
}

class UploadVisaInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadVisaInfoScreen(),
    );
  }
}

class UploadVisaInfoScreen extends StatefulWidget {
  @override
  _UploadVisaInfoScreenState createState() => _UploadVisaInfoScreenState();
}

class _UploadVisaInfoScreenState extends State<UploadVisaInfoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController authorityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImage;
  String? currentUserEmail;

  String? selectedVisaType;
  final List<String> visaTypes = [
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
    'Retirement Visa',]; // Add other types here

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
  }

  Future<void> _getCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('loggedInUserEmail') ?? 'unknown@example.com';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _uploadVisaInfo() async {
    String title = titleController.text;
    String issueDate = issueDateController.text;
    String expirationDate = expirationDateController.text;
    String authority = authorityController.text;
    String description = descriptionController.text;

    if (selectedVisaType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a visa type")),
      );
      return;
    }

    String? imagePath;
    if (_selectedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageFileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await _selectedImage!.copy('${directory.path}/$imageFileName');
      imagePath = savedImage.path;
    }

    final visaInfo = VisaInfo(
      title: title,
      visaType: selectedVisaType!,
      issueDate: issueDate,
      expirationDate: expirationDate,
      authority: authority,
      description: description,
      imagePath: imagePath,
      userEmail: currentUserEmail,
    );
    await DatabaseHelper.instance.insertVisaInfo(visaInfo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Visa info uploaded successfully!")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:   AppBar(
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyhomeAD()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Visa Title
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Visa Type Dropdown
                  Container(
                    width: 320,
                    child: DropdownButtonFormField<String>(
                      value: selectedVisaType,
                      hint: Text("Select Visa Type"),
                      items: visaTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedVisaType = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Issue Date
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: issueDateController,
                      decoration: InputDecoration(
                        hintText: "Issue Date",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  // Expiration Date
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: expirationDateController,
                      decoration: InputDecoration(
                        hintText: "Expiration Date",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),

                    ),
                  ),
                  const SizedBox(height: 20),
                  // Issuing Authority
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: authorityController,
                      decoration: InputDecoration(
                        hintText: "Issuing Authority",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Description",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 30,),
                        Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[200],
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!, fit: BoxFit.cover)
                              : Center(child: Icon(Icons.add_photo_alternate, size: 50,
                            color: Color.fromARGB(255, 145, 3, 53),)),
                        ),
                        SizedBox(width: 10,),
                        Text("upload a picture",
                          style:TextStyle(
                            color: Color.fromARGB(255, 145, 3, 53),
                            fontWeight: FontWeight.bold,
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadVisaInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                    ),
                    child: Text("Upload Visa Info",style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
