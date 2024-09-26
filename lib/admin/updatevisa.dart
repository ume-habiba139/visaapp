import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../Database/database_helper.dart';

class UpdateVisaInfoScreen extends StatefulWidget {
  final VisaInfo visaInfo;

  const UpdateVisaInfoScreen({super.key, required this.visaInfo});

  @override
  _UpdateVisaInfoScreenState createState() => _UpdateVisaInfoScreenState();
}

class _UpdateVisaInfoScreenState extends State<UpdateVisaInfoScreen> {
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
    'Retirement Visa',
  ];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.visaInfo.title;
    issueDateController.text = widget.visaInfo.issueDate;
    expirationDateController.text = widget.visaInfo.expirationDate;
    authorityController.text = widget.visaInfo.authority;
    descriptionController.text = widget.visaInfo.description;
    selectedVisaType = widget.visaInfo.visaType;
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

  Future<void> _updateVisaInfo() async {
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

    final updatedVisaInfo = VisaInfo(
      id: widget.visaInfo.id,
      title: title,
      visaType: selectedVisaType!,
      issueDate: issueDate,
      expirationDate: expirationDate,
      authority: authority,
      description: description,
      imagePath: imagePath,
      userEmail: currentUserEmail,
    );

    await DatabaseHelper.instance.updateVisaInfo(updatedVisaInfo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Visa info updated successfully!")),
    );

    Navigator.pop(context, true); // Return true to indicate the post was updated
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Visa Info"),
        backgroundColor: Color.fromARGB(255, 145, 3, 53),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
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
              SizedBox(height: 10),
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
              TextFormField(
                controller: issueDateController,
                decoration: InputDecoration(
                  hintText: "Issue Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 229, 226, 229),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: expirationDateController,
                decoration: InputDecoration(
                  hintText: "Expiration Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 229, 226, 229),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: authorityController,
                decoration: InputDecoration(
                  hintText: "Issuing Authority",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 229, 226, 229),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 229, 226, 229),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[200],
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : Center(child: Icon(Icons.add_photo_alternate, size: 50, color: Color.fromARGB(255, 145, 3, 53))),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateVisaInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                ),
                child: Text("Update Visa Info", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
