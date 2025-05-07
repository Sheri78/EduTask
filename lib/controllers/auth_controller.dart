import 'package:edutask/controllers/task_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edutask/screens/student/student_home_page.dart';
import 'package:edutask/screens/auth/login_screen.dart';

import '../screens/admin/admin_home_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Observables
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  User? get user => _firebaseUser.value;
  bool get isLoggedIn => _firebaseUser.value != null;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _handleAuthStateChange);
    super.onInit();
  }

  void _handleAuthStateChange(User? user) async {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      final role = await getUserRole(user.uid);
      if (role == 'admin') {
        Get.offAll(() => AdminHomeScreen());
      } else {
        Get.offAll(() => StudentHomeScreen());
      }
    }
  }


  // Email & Password Authentication
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String role, // 'student' or 'admin'
  }) async {
    try {
      isLoading(true);
      errorMessage('');

      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'uid': credential.user?.uid,
        'email': email,
        'username': username,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _saveCredentials(email, password);
    } on FirebaseAuthException catch (e) {
      errorMessage(_getAuthErrorMessage(e));
      rethrow;
    } catch (e) {
      errorMessage('An unexpected error occurred. Please try again.');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
   }) async {
    try {
      isLoading(true);
      errorMessage('');

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (rememberMe) {
        await _saveCredentials(email, password);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage(_getAuthErrorMessage(e));
      rethrow;
    } catch (e) {
      errorMessage('An unexpected error occurred. Please try again.');
      rethrow;
    } finally {
      isLoading(false);
    }
  }
  Future<void> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        final role = userDoc['role'];
        if (role == 'admin') {
          Get.offAll(() => AdminHomeScreen());
          Fluttertoast.showToast(msg: 'Admin login successful');
        } else {
          Get.offAll(() => StudentHomeScreen());
          Fluttertoast.showToast(msg: 'Student login successful');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Login failed');
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      isLoading(true);
      errorMessage('');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Save user data if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'email': userCredential.user?.email,
          'username': userCredential.user?.displayName ?? 'Google User',
          'role': 'student', // Default role for Google sign-in
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      errorMessage('Google sign-in failed. Please try again.');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading(true);
      errorMessage('');
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      errorMessage(_getAuthErrorMessage(e));
      rethrow;
    } catch (e) {
      errorMessage('Failed to send reset email. Please try again.');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Logout
  // Future<void> logout() async {
  //   try {
  //     await _auth.signOut();
  //     await _googleSignIn.signOut();
  //     await _clearCredentials();
  //   } catch (e) {
  //     errorMessage('Logout failed. Please try again.');
  //     rethrow;
  //   }
  // }
  void logout() async {
    await _auth.signOut();
    Get.find<TaskController>().tasks.clear(); // 👈 Clear old tasks
    Get.offAll(() => LoginPage());
  }


  // Helper Methods
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // Local Storage
  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  // User Role Management
  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'student';
  }

  // Check if current user is admin
  Future<bool> isAdmin() async {
    if (_firebaseUser.value == null) return false;
    final role = await getUserRole(_firebaseUser.value!.uid);
    return role == 'admin';
  }
}