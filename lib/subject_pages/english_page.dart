import 'package:flutter/material.dart';
import 'package:reddays/data/english_flashcard1_data.dart'; // Import the English flashcard data

class EnglishPage extends StatefulWidget {
  @override
  _MathPageState createState() => _MathPageState();
}

class _MathPageState extends State<EnglishPage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  void _showNextCard() {
    setState(() {
      if (_currentIndex < simplifiedFlashcards.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _showPreviousCard() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('English - Flashcards', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            Text(
              'English Flashcards',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Review and test your English vocabulary using these flashcards!',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),

            // Flashcard Navigation
            Flashcard(
              question: simplifiedFlashcards[_currentIndex]['question']!,
              answer: simplifiedFlashcards[_currentIndex]['answer']!,
            ),

            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showPreviousCard,
                  child: Text('Previous'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _showNextCard,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Flashcard extends StatefulWidget {
  final String question;
  final String answer;

  const Flashcard({
    required this.question,
    required this.answer,
  });

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> with TickerProviderStateMixin {
  bool _showAnswer = false;

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      child: Card(
        elevation: 5, // Slightly higher elevation for better depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 8), // Margin between cards
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          title: _showAnswer
              ? Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                )
              : Text(
                  widget.question,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
          trailing: IconButton(
            icon: Icon(
              _showAnswer ? Icons.visibility_off : Icons.visibility,
              color: Colors.teal,
            ),
            onPressed: _toggleAnswer,
          ),
        ),
      ),
    );
  }
}
