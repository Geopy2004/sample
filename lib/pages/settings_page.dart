import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'contact_page.dart'; // Import your contacts page

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Log out function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .pushReplacementNamed('/signin'); // Redirect to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  // Show About Us dialog
  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Us"),
        content: const Text(
          "Flashcarton is an innovative flashcard app designed to make learning easy and fun. "
          "Developed by passionate creators, we aim to help students and professionals alike achieve their goals.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Navigate to the contacts page
  void _goToContactsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactsPage()), // Navigate to ContactsPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true, // Replaces the "Flashcarton" title
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Us option
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text("About Us"),
              onTap: () => _showAboutUsDialog(context),
            ),
            const Divider(),

            // Contact option
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.green),
              title: const Text("Contact"),
              onTap: () =>
                  _goToContactsPage(context), // Navigate to the ContactsPage
            ),
            const Divider(),

            // Logout option
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
