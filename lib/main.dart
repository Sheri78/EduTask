import 'package:edutask/controllers/auth_controller.dart';
import 'package:edutask/screens/student/student_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutask/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the AuthController
    Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduTask',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() {
      if (authController.user != null) {
        return StudentHomeScreen();
      } else {
        return LoginPage();
      }
    });
  }
}