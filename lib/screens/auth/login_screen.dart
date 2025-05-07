import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:edutask/controllers/auth_controller.dart';
import 'package:edutask/screens/auth/sign_up.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RxBool _rememberMe = false.obs;

  LoginPage({super.key});

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
                SizedBox(height: 30),
                Center(
                  child: Lottie.asset(
                    'assets/animations/login.json',
                    height: 350,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 5),
                Text("Sign in to continue", style: TextStyle(fontSize: 18, color: Colors.grey)),
                SizedBox(height: 25),

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
                  validator: (value) => value!.isEmpty ? "Please enter your email" : null,
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
                  validator: (value) => value!.isEmpty ? "Please enter password" : null,
                ),
                SizedBox(height: 10),

                // Remember Me & Forgot Password
                Row(
                  children: [
                    Obx(() => Checkbox(
                      value: _rememberMe.value,
                      onChanged: (value) => _rememberMe.value = value!,
                    )),
                    Text("Remember me"),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        if (_emailController.text.isNotEmpty) {
                          authController.sendPasswordResetEmail(_emailController.text.trim());
                        } else {
                          Get.snackbar("Error", "Please enter your email first");
                        }
                      },
                      child: Text("Forgot Password?", style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        authController.loginWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          rememberMe: _rememberMe.value,
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
                        : Text("Sign in", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )),

                SizedBox(height: 15),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => Get.to(() => SignUpPage()),
                      child: Text("Sign Up", style: TextStyle(
                          color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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