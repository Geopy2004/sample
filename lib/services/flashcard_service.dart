import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> fetchFlashcards(String subject) {
    return _firestore.collection('flashcards/$subject/cards').snapshots().map(
      (snapshot) {
        return Map.fromEntries(
          snapshot.docs.map(
            (doc) => MapEntry(doc.id, doc.data()),
          ),
        );
      },
    );
  }

  Future<void> addFlashcard(
      String subject, String question, String answer) async {
    await _firestore.collection('flashcards/$subject/cards').add({
      'question': question,
      'answer': answer,
    });
  }

  Future<void> updateFlashcard(
      String subject, String id, String question, String answer) async {
    await _firestore.collection('flashcards/$subject/cards').doc(id).update({
      'question': question,
      'answer': answer,
    });
  }

  Future<void> deleteFlashcard(String subject, String id) async {
    await _firestore.collection('flashcards/$subject/cards').doc(id).delete();
  }
}
