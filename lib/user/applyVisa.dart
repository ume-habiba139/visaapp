import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visaapp/Database/database_helper.dart';

class ApplyVisaScreen extends StatefulWidget {
  final String visaTitle;

  ApplyVisaScreen({required this.visaTitle});

  @override
  _ApplyVisaScreenState createState() => _ApplyVisaScreenState();
}

class _ApplyVisaScreenState extends State<ApplyVisaScreen> {

  final fullNameController = TextEditingController();
  final dateofBirthController = TextEditingController();
  final passportNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryofResidenceController = TextEditingController();
  final additionalController = TextEditingController();
  final visaTypeController=TextEditingController();


  Future<void> _uploadVisaInfo() async {
    String fullName = fullNameController.text;
    String dateofBirth = dateofBirthController.text;
    String passportNumber = passportNumberController.text;
    String emailAddress = emailAddressController.text;
    String phoneNumber = phoneNumberController.text;
    String countryofResidence = countryofResidenceController.text;
    String additional = additionalController.text;
    String visatype=visaTypeController.text;


    String? imagePath;
    if (_image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageFileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await _image!.copy('${directory.path}/$imageFileName');
      imagePath = savedImage.path;
    }
    if (selectedVisaType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a visa type")),
      );
      return;
    }

    final applyVisa = ApplyVisa(
      fullName: fullName,
      dateofBirth: dateofBirth,
      PassportNumber: passportNumber,
      EmailAddress: emailAddress,
      PhoneNumber: phoneNumber,
      CountryofResidence: countryofResidence,
      Additional: additional,
      imagePath:imagePath,
      visaType: selectedVisaType!,
    );

    await DatabaseHelper.instance.applyVisainfo(applyVisa);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Visa info applied successfully!")),
    );

  }


  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 229, 226, 229),
    );
  }
  String? selectedVisaType;

  @override
  Widget build(BuildContext context) {


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
      'Retirement Visa',];
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.visaTitle}'),
        backgroundColor: Color.fromARGB(255, 145, 3, 53),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: fullNameController,
                decoration: _inputDecoration('Full Name'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: dateofBirthController,
                decoration: _inputDecoration('Date of Birth'),
                onTap: () {
                  // Add Date Picker logic here
                },
              ),
              SizedBox(height: 15),
              TextField(
                controller: passportNumberController,
                decoration: _inputDecoration('Passport Number'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailAddressController,
                decoration: _inputDecoration('Email Address'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: phoneNumberController,
                decoration: _inputDecoration('Phone Number'),
              ),
              SizedBox(height: 15),
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
                  decoration: _inputDecoration("Select Visa Type"),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: countryofResidenceController,
                decoration: _inputDecoration('Country of Residence'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: additionalController,
                decoration: _inputDecoration('Additional Notes (Optional)'),
              ),
              SizedBox(height: 20),

              // Image Picker Section
              Text(
                "Upload Your Passport Photo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(
                _image!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Text("No image selected."),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 145, 3, 53),
                ),
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadVisaInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 145, 3, 53),
                ),
                child: Text(
                  'Apply Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
