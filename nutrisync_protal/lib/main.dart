import 'package:NutriSync/screens/login_screen.dart';
import 'package:NutriSync/screens/splash_screen.dart';
import 'package:NutriSync/screens/main_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const NutriSyncApp());
}

class NutriSyncApp extends StatelessWidget {
  const NutriSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriSync App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
