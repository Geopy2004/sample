import 'package:flutter/material.dart';
import 'package:reddays/quiz/english_quiz.dart';
import 'package:reddays/quiz/math_quiz.dart';

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Subjects',
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
              color: Colors.redAccent,
              title: "Math Quiz",
              letter: "M",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MathQuizPage()),
                );
              },
            ),
            SubjectCard(
              color: Colors.lightBlue,
              title: "Science Quiz",
              letter: "S",
              onTap: () {
                // Navigate to Science Quiz Page
              },
            ),
            SubjectCard(
              color: Colors.grey,
              title: "Filipino Quiz",
              letter: "F",
              onTap: () {
                // Navigate to Filipino Quiz Page
              },
            ),
            SubjectCard(
              color: Colors.orangeAccent,
              title: "History Quiz",
              letter: "H",
              onTap: () {
                // Navigate to History Quiz Page
              },
            ),
            SubjectCard(
              color: Colors.purple,
              title: "Music Quiz",
              letter: "M",
              onTap: () {
                // Navigate to Music Quiz Page
              },
            ),
            SubjectCard(
              color: Colors.pinkAccent,
              title: "English Quiz",
              letter: "E",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnglishQuizPage()),
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
