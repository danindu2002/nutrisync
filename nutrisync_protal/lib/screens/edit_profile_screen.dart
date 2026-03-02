import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    _firstNameController.text = prefs.getString('firstName') ?? "John";
    _lastNameController.text = prefs.getString('lastName') ?? "Smith";
    _emailController.text = prefs.getString('email') ?? "johnsmith@gmail.com";
    _dobController.text = prefs.getString('dob') ?? "12/05/2000";

    final imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      _profileImage = File(imagePath);
    }

    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
    await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('firstName', _firstNameController.text);
    await prefs.setString('lastName', _lastNameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('dob', _dobController.text);

    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.grey],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage("assets/images/profile.jpg")
                            as ImageProvider,
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${_firstNameController.text} ${_lastNameController.text}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _buildField("First Name", _firstNameController),
              _buildField("Last Name", _lastNameController),
              _buildField("Email", _emailController),
              _buildDateField(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Date of Birth"),
          const SizedBox(height: 6),
          TextField(
            controller: _dobController,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );

              if (picked != null) {
                _dobController.text =
                "${picked.day}/${picked.month}/${picked.year}";
              }
            },
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}