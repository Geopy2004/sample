import 'package:firebase_database/firebase_database.dart';

class LeaderboardService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('leaderboard');

  /// Fetches leaderboard data from Firebase and returns it as a sorted list.
  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    try {
      final snapshot = await _database.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final List<Map<String, dynamic>> leaderboard = [];
        data.forEach((key, value) {
          leaderboard.add({
            'id': key,
            'name': value['name'],
            'score': value['score'],
          });
        });

        // Sort by score in descending order
        leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
        return leaderboard;
      } else {
        return []; // Return empty list if no data exists
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return []; // Return empty list on error
    }
  }

  /// Adds a new entry to the leaderboard.
  Future<void> addEntry(String name, int score) async {
    try {
      await _database.push().set({'name': name, 'score': score});
    } catch (e) {
      print('Error adding entry: $e');
    }
  }

  /// Updates an existing entry by ID.
  Future<void> updateEntry(String id, int newScore) async {
    try {
      await _database.child(id).update({'score': newScore});
    } catch (e) {
      print('Error updating entry: $e');
    }
  }

  /// Deletes an entry by ID.
  Future<void> deleteEntry(String id) async {
    try {
      await _database.child(id).remove();
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }
}
