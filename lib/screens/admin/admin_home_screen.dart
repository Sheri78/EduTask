import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'admin_profile_screen.dart';
import 'user_management_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildAppDrawer(),
      body: Column(
        children: [
          // Gradient Header
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF66a6ff), Color(0xFF89f7fe)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 15),
            child: Stack(
              children: [
                // Menu button top-left
                Positioned(
                  top: 0,
                  left: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome Back!\nEduTask Admin',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Prioritize Organize Execute',
                              style: TextStyle(color: Colors.white70, fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Image.asset('assets/images/admin.png', height: MediaQuery.of(context).size.height * 0.25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Options List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('View Profile'),
                  onTap: () => Get.to(() => AdminProfileScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Manage Users'),
                  onTap: () => Get.to(() => UserManagementScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF66a6ff), Color(0xFF89f7fe)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 30, color: Color(0xFF396afc)),
                ),
                const SizedBox(height: 10),
                Text(
                  _authController.user?.email ?? 'Admin User',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Profile'),
            onTap: () {
              Get.back();
              Get.to(() => AdminProfileScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Manage Users'),
            onTap: () {
              Get.back();
              Get.to(() => UserManagementScreen());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.back();
              _authController.logout();
              Get.snackbar('Logged out', 'Admin signed out successfully');
            },
          ),
        ],
      ),
    );
  }
}
