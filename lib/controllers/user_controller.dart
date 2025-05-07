import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<AppUser?> _user = Rx<AppUser?>(null);
  final RxBool isInitialized = false.obs; // ✅ Added

  AppUser? get user => _user.value;

  @override
  void onInit() {
    _initializeUser();
    super.onInit();
  }

  Future<void> _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fetchUserData(user.uid);
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _user.value = null;
        isInitialized.value = false;
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user.value = AppUser.fromMap({...doc.data()!, 'uid': uid});
        isInitialized.value = true; // ✅ Set true when ready
      } else {
        // Create if missing
        await _firestore.collection('users').doc(uid).set({
          'email': FirebaseAuth.instance.currentUser?.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _fetchUserData(uid);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    }
  }

  Future<void> updateUserInfo({String? name, String? phone}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _firestore.collection('users').doc(user.uid).update({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _fetchUserData(user.uid);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
      rethrow;
    }
  }
}
