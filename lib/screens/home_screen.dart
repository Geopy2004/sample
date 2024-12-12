import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reddays/pages/flashcard_page.dart';
import 'package:reddays/pages/leaderboard_page.dart';
import 'package:reddays/pages/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user;
  String username = "Adventurer"; // Default username
  int _currentIndex = 0; // Tracks the selected tab
  late PageController _pageController; // Controller for PageView

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _pageController = PageController(); // Initialize PageController
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    if (user != null) {
      try {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            username = userDoc['username'] ?? "Adventurer";
          });
        }
      } catch (e) {
        print("Error fetching username: $e");
        setState(() {
          username = "Adventurer"; // Fallback username in case of an error
        });
      }
    }
  }

  // Helper function to convert hex string to Color
  Color hexStringToColor(String hexColor) {
    try {
      final buffer = StringBuffer();
      if (hexColor.length == 6 || hexColor.length == 7) {
        buffer
            .write('FF'); // Add full opacity if the alpha value is not provided
      }
      buffer.write(hexColor.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      print("Invalid hex color: $hexColor");
      return Colors.black; // Fallback color
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor('1DA1F2'), // Blue color
              hexStringToColor('657786'), // Greyish color
              hexStringToColor('14171A'), // Dark color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left
          children: [
            const SizedBox(height: 20), // Adjust the spacing from the top

            // App Icon and Name - Positioned at the top left, with smaller size
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/skull.png', // Replace with your app's icon
                    height: 40, // Smaller size for the app icon
                    width: 40,
                  ),
                  const SizedBox(
                      width: 8), // Reduced spacing between icon and text
                  const Text(
                    'Flashcarton', // Replace with your app's name
                    style: TextStyle(
                      fontSize: 20, // Smaller font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30), // Spacing before the greeting message

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  // Pages for each tab
                  Center(
                    child: Text(
                      "Welcome, $username!",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  LeaderboardScreen(),
                  FlashcardQuizHome(),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut, // Smooth transition
          );
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Leaderboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Flashcards",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
