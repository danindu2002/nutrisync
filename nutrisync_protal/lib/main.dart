import 'package:NutriSync/screens/home/main_navigation_screen.dart';
import 'package:NutriSync/screens/home/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase_options.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const NutriSyncApp());
}

class NutriSyncApp extends StatelessWidget {
  const NutriSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'NutriSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorKey: NavigationService.navigatorKey,
      home: const SplashScreen(),
    );
  }
}
