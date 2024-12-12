import 'package:flutter/material.dart';
import 'package:reddays/quiz/quiz_page.dart';
import 'package:reddays/subject_pages/subjects.dart';

class FlashcardQuizHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcarton'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flashcard & Quiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            // Flashcards Option
            MenuCard(
              title: 'Flashcards',
              color: Colors.blueAccent,
              icon: Icons.note_alt_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectsScreen()),
                );
              },
            ),
            SizedBox(height: 15),
            // Quiz Option
            MenuCard(
              title: 'Quiz',
              color: Colors.greenAccent,
              icon: Icons.quiz_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz()),
                );
                // Add navigation to Quiz Screen (if needed)
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  MenuCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
