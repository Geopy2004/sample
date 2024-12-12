import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reddays/screens/signin_screen.dart';
import 'package:reddays/screens/signup_screen.dart';

// Firebase configuration for Web
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCd9L7-oHfA6pGnnw8SO6Y9BHOyFZ6WIUE",
  appId: "1:669280958958:android:a790219abc65f8240ff6ff",
  messagingSenderId: "669280958958",
  projectId: "aeither-d5e8c",
  authDomain: "aeither-d5e8c.firebaseapp.com",
  databaseURL: "aeither-d5e8c-default-rtdb.firebaseio.com",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(options: firebaseOptions);
    runApp(const MyApp());
  } catch (e) {
    // Show error screen if Firebase initialization fails
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text(
          'Error initializing Firebase: $e',
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RedDays',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignupScreen(),
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/signin': (context) => const SigninScreen(),
        '/firestoreTest': (context) => const FirestoreTestScreen(),
      },
    );
  }
}

// Example Firestore interaction screen
class FirestoreTestScreen extends StatefulWidget {
  const FirestoreTestScreen({super.key});

  @override
  State<FirestoreTestScreen> createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Test")),
      body: ElevatedButton(
        onPressed: () async {
          try {
            await _usersCollection.add({
              'username': 'TestUser',
              'email': 'testuser@example.com',
              'created_at': Timestamp.now(),
            });
          } catch (e) {
            print('Error: $e');
          }
        },
        child: const Text("Add User to Firestore"),
      ),
    );
  }
}
