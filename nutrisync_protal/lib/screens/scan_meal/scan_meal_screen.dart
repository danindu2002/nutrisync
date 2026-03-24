import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants.dart';
import 'brief_screen.dart';

class ScanMealScreen extends StatefulWidget {
  const ScanMealScreen({super.key});

  @override
  State<ScanMealScreen> createState() => _ScanMealScreenState();
}

class _ScanMealScreenState extends State<ScanMealScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Show picker options immediately after screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPickerOptions();
    });
  }

  /// Bottom sheet to choose Camera or Gallery
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Select from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Pick image from selected source and pass to BriefScreen
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);

      if (image == null) {
        // If user cancels, go back to previous screen
        if (mounted) Navigator.pop(context);
        return;
      }

      // Navigate to BriefScreen and pass the selected image file
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BriefScreen(imageFile: File(image.path)),
          ),
        );
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(color: Colors.black),
          ),
          // Center UI
          const Center(
            child: Text(
              "Preparing Camera...",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}