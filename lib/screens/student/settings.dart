import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserController _userController;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userController = Get.put(UserController());

    ever(_userController.isInitialized, (isInitialized) {
      if (isInitialized == true) {
        _nameController = TextEditingController(
            text: _userController.user?.name ?? '');
        _phoneController = TextEditingController(
            text: _userController.user?.phone ?? '');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (!_isLoading) {
      _nameController.dispose();
      _phoneController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8746E),
        title: const Text('Settings'),
      ),
      floatingActionButton: FloatingActionButton(

        backgroundColor: Color(0xFFF8746F),
        onPressed: () { _isLoading ? null : _saveProfile(); },
        child: const Icon(Icons.save),


      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfoSection(),
              const SizedBox(height: 24),
              _buildEditableFormSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(_userController.user?.email ?? 'No email'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User ID'),
              subtitle: Text(
                _userController.user?.uid ?? '',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableFormSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    try {
      await _userController.updateUserInfo(
        name: _nameController.text,
        phone: _phoneController.text,
      );
    } catch (_) {
      // already handled in controller
    }
  }
}
