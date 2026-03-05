import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'brief_screen.dart';
import '../core/constants.dart';

class ScanMealScreen extends StatefulWidget {
  const ScanMealScreen({super.key});

  @override
  State<ScanMealScreen> createState() => _ScanMealScreenState();
}

class _ScanMealScreenState extends State<ScanMealScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

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
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: AppColors.primary),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AppColors.primary),
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

  /// Pick image from selected source
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image =
      await _picker.pickImage(source: source);

      if (image == null) {
        // If user cancels, go back
        if (mounted) Navigator.pop(context);
        return;
      }

      await _uploadImage(File(image.path));
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  /// Mock multipart upload (always success)
  Future<void> _uploadImage(File imageFile) async {
    try {
      setState(() => _isProcessing = true);

      // --- MOCK MULTIPART API CALL ---
      // In real scenario:
      /*
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("YOUR_API_URL"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var response = await request.send();
      */

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Always success → Navigate to Brief
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const BriefScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
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
          Center(
            child: _isProcessing
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(height: 15),
                Text(
                  "Uploading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            )
                : const Text(
              "Preparing...",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}