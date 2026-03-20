import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _existingprofileImage;
  String? _newImagePath;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? "";
      _lastNameController.text = prefs.getString('lastName') ?? "";
      _emailController.text = prefs.getString('email') ?? "";

      // Load and format the existing DOB for the UI (d/M/yyyy)
      String storedDob = prefs.getString('dob') ?? "";
      if (storedDob.isNotEmpty) {
        DateTime parsed = DateTime.parse(storedDob);
        _dobController.text = DateFormat('d/M/yyyy').format(parsed);
      }

      // Load the existing Base64 string from memory
      _existingprofileImage = prefs.getString('profileImage');
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _newImagePath = image.path);
    }
  }

  // Helper method to decide which image to show in the UI
  ImageProvider? _getProfileImageProvider() {
    if (_newImagePath != null && _newImagePath!.isNotEmpty) {
      return FileImage(File(_newImagePath!));
    }

    if (_existingprofileImage != null && _existingprofileImage!.isNotEmpty) {
      try {
        final cleanBase64 = _existingprofileImage!.contains(',')
            ? _existingprofileImage!.split(',').last
            : _existingprofileImage!;
        final decodedBytes = base64Decode(
          cleanBase64.replaceAll(RegExp(r'\s+'), ''),
        );
        return MemoryImage(decodedBytes);
      } catch (e) {
        debugPrint("Error decoding base64: $e");
      }
    }

    return null; // Show default icon if both are null
  }

  // Safely converts the UI date (d/M/yyyy) back to API format (yyyy-MM-dd)
  String convertDateFormat(String dob) {
    if (dob.isEmpty) return "";

    try {
      dob = dob.trim();
      DateTime date = DateFormat('d/M/yyyy').parse(dob);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      try {
        // fallback ISO parsing
        DateTime date = DateTime.parse(dob.trim());
        return DateFormat('yyyy-MM-dd').format(date);
      } catch (_) {
        print("Date parse failed for: $dob");
        return dob;
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _dobController.text.isEmpty) {
      showModernToast(context, "Please fill in all required fields", type: 'error');
      return;
    }

    File? uploadFile;
    if (_newImagePath != null && _newImagePath!.isNotEmpty) {
      uploadFile = File(_newImagePath!);
      if (!uploadFile.existsSync()) {
        showModernToast(context, "Invalid image file. Please reselect.", type: 'error');
        return;
      }
    } else if (_existingprofileImage == null || _existingprofileImage!.isEmpty) {
      showModernToast(context, "Please select a profile picture", type: 'error');
      return;
    } else if (_existingprofileImage != null && _existingprofileImage!.isNotEmpty) {
      try {
        final cleanBase64 = _existingprofileImage!.contains(',')
            ? _existingprofileImage!.split(',').last
            : _existingprofileImage!;
        final decodedBytes = base64Decode(
          cleanBase64.replaceAll(RegExp(r'\s+'), ''),
        );
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_profile_image.png');
        await tempFile.writeAsBytes(decodedBytes);
        uploadFile = tempFile;
      } catch (e) {
        debugPrint("Error preparing existing image for upload: $e");
        showModernToast(context, "Failed to prepare existing profile image. Please reselect.", type: 'error');
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");

    try {
      LoadingIndicator.show(context);

      final apiDob = convertDateFormat(_dobController.text);

      final response = await AuthService.updateProfile(
        userId!,
        uploadFile!,
        {
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "email": _emailController.text,
          "dob": _dobController.text,
        },
      );
      if (mounted) LoadingIndicator.hide(context);

      if (response.status == 200) {
        await prefs.setString('firstName', _firstNameController.text);
        await prefs.setString('lastName', _lastNameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('dob', _dobController.text);

        if (_newImagePath != null) {
          await prefs.setString('profileImage', _newImagePath!);
        }

        if (mounted) {
          showModernToast(context, "Profile updated successfully!", type: 'success');
          Navigator.pop(context, true);
        }
      } else {
        Logger.error("Failed to update profile: ${response.message}");
        showModernToast(context, response.message.isNotEmpty ? response.message : "Failed to update profile", type: 'error');
      }
    } catch (e) {
      Logger.error("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// ===== HEADER (Black Gradient) =====
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Color(0xFF2B2B2B)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                        const SizedBox(height: 10),

                        /// Profile Picture with Edit Icon
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade800,
                                  backgroundImage: _getProfileImageProvider(),
                                  child: _getProfileImageProvider() == null
                                      ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ===== FORM FIELDS =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildInputField("First Name", _firstNameController),
                    _buildInputField("Last Name", _lastNameController),
                    _buildInputField(
                      "Email",
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildInputField(
                      "Date of Birth",
                      _dobController,
                      isDate: true,
                    ),

                    const SizedBox(height: 10),

                    /// Save Button
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 55),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller, {
        TextInputType? keyboardType,
        bool isDate = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: isDate,
            onTap: isDate
                ? () async {
              // 1. Determine the currently selected date to show in the picker
              DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 25));

              if (controller.text.isNotEmpty) {
                try {
                  // Parse existing UI text (d/M/yyyy) back into a DateTime
                  initialDate = DateFormat('d/M/yyyy').parseStrict(controller.text);
                } catch (e) {
                  // If it fails, fallback to the default initialDate
                }
              }

              // 2. Open the Date Picker
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );

              // 3. Set the new date back to the controller
              if (pickedDate != null) {
                setState(() {
                  controller.text = DateFormat('d/M/yyyy').format(pickedDate);
                });
              }
            }
                : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Enter $label",
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}