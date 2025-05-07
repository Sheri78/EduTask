import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutask/controllers/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:edutask/screens/auth/login_screen.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Lottie.asset('assets/animations/signup.json', height: 450),
                ),
                SizedBox(height: 0),
                Text(
                  "Register",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 5),
                Text(
                  "Create an account to get started.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 15),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                ),
                SizedBox(height: 15),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter your email";
                    if (!GetUtils.isEmail(value)) return "Please enter a valid email";
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter password";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Please confirm password";
                    if (value != _passwordController.text) return "Passwords don't match";
                    return null;
                  },
                ),
                SizedBox(height: 30),

                // Sign Up Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        authController.registerWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          username: _usernameController.text.trim(),
                          role: 'student', // Default role
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: authController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Get.to(() => LoginPage()),
                      child: Text("Sign In", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}