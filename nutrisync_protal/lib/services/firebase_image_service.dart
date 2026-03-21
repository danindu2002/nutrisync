import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/common_widgets.dart'; // To use your Logger

class FirebaseImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndUploadImage() async {
    try {
      // 1. Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compresses the image to save bandwidth
      );

      if (image == null) {
        Logger.info("User canceled image selection.");
        return null;
      }

      File file = File(image.path);

      // 2. Create a unique path in Firebase Storage
      String fileName = 'meal_plans/plan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // 3. Upload the file
      Logger.info("Uploading image to Firebase...");
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // 4. Retrieve and return the live URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      Logger.success("Upload Success! URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      Logger.error("Error uploading image: $e");
      return null;
    }
  }
}