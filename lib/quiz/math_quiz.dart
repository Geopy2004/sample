import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MathQuizPage(),
    );
  }
}

class Question {
  final String question;
  final String answer;

  Question({required this.question, required this.answer});

  factory Question.fromMap(Map<dynamic, dynamic> data) {
    return Question(
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class HighScore {
  final int score;
  final int timestamp;

  HighScore({required this.score, required this.timestamp});

  factory HighScore.fromMap(Map<dynamic, dynamic> data) {
    return HighScore(
      score: data['score'] ?? 0,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'timestamp': timestamp,
    };
  }
}

class MathQuizPage extends StatefulWidget {
  @override
  _MathQuizPageState createState() => _MathQuizPageState();
}

class _MathQuizPageState extends State<MathQuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  String _userAnswer = '';
  bool _answered = false;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  // Fetch questions from Firebase Realtime Database
  void _fetchQuestions() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    
    // Fetch the 'questions' node
    DataSnapshot snapshot = await databaseReference.child('questions').once();
    
    if (snapshot.value != null) {
      Map<String, dynamic> questionsMap = snapshot.value;
      setState(() {
        _questions = questionsMap.entries.map((entry) {
          return Question.fromMap(entry.value);
        }).toList();
      });
    }
  }

  void _submitAnswer() {
    if (_userAnswer.isEmpty) return;

    setState(() {
      _answered = true;
      if (_userAnswer == _questions[_currentIndex].answer) {
        _score++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Incorrect! The correct answer is: ${_questions[_currentIndex].answer}'),
          ),
        );
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _userAnswer = '';
      _answered = false;

      if (_currentIndex >= _questions.length) {
        _endQuiz();
      }
    });
  }

  void _saveScore() async {
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child('highScores').push().set(HighScore(
      score: _score,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ).toMap());
  }

  void _endQuiz() {
    _saveScore();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Math Quiz'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_currentIndex >= _questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Completed'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score: $_score/${_questions.length}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Math Quiz'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Question ${_currentIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Flashcard(
              question: currentCard.question,
              onAnswerEntered: (String answer) {
                _userAnswer = answer;
                _submitAnswer();
              },
              answered: _answered,
            ),
            if (_answered)
              ElevatedButton(
                onPressed: _currentIndex < _questions.length - 1
                    ? _nextQuestion
                    : null,
                child: Text('Next Question'),
              ),
          ],
        ),
      ),
    );
  }
}

class Flashcard extends StatelessWidget {
  final String question;
  final Function(String) onAnswerEntered;
  final bool answered;

  const Flashcard({
    required this.question,
    required this.onAnswerEntered,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _answerController = TextEditingController();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(
          question,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: !answered
            ? TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Your answer',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  onAnswerEntered(value);
                  _answerController.clear();
                },
              )
            : null,
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Top Scores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('highScores')
                    .orderByChild('score')
                    .limitToLast(10)
                    .onValue, // Real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || !snapshot.data!.snapshot.exists) {
                    return Center(child: Text('No high scores yet.'));
                  }

                  Map<String, dynamic> scoresMap = snapshot.data!.snapshot.value;
                  List<HighScore> scores = scoresMap.values.map((e) => HighScore.fromMap(e)).toList();

                  return ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      var score = scores[index];
                      return ListTile(
                        title: Text('Score ${index + 1}: ${score.score}'),
                        subtitle: Text('Timestamp: ${score.timestamp}'),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
