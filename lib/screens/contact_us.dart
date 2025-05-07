import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Color(0xFFF8746E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'University of Engineering and Technology (UET) Lahore',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text('Phone'),
                  subtitle: Text('+966 501201890'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Email'),
                  subtitle: Text('support@edutask.com'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
