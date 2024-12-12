import 'package:flutter/material.dart';
import 'package:reddays/subject_pages/english_page.dart';
import 'package:reddays/subject_pages/math_page.dart'; // Replace with your actual path

class SubjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flashcard Subjects',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SubjectCard(
              color: Colors.yellow,
              title: "Math",
              letter: "M",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MathPage()),
                );
              },
            ),
            SubjectCard(
              color: Colors.green,
              title: "Science",
              letter: "S",
              onTap: () {
                // Add navigation for Science Page
              },
            ),
            SubjectCard(
              color: Colors.grey,
              title: "Filipino",
              letter: "F",
              onTap: () {
                // Add navigation for Filipino Page
              },
            ),
            SubjectCard(
              color: Colors.orange,
              title: "History",
              letter: "H",
              onTap: () {
                // Add navigation for History Page
              },
            ),
            SubjectCard(
              color: Colors.grey,
              title: "Music",
              letter: "M",
              onTap: () {
                // Add navigation for Music Page
              },
            ),
            SubjectCard(
              color: Colors.pink,
              title: "English",
              letter: "E",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnglishPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Color color;
  final String title;
  final String letter;
  final VoidCallback onTap;

  SubjectCard({
    required this.color,
    required this.title,
    required this.letter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            letter,
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.teal),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
