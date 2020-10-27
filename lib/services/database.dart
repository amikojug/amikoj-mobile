import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int lostGames, int winGames, int winStreak,
      int ranking) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'lostGames': lostGames,
      'winGames': winGames,
      'winStreak': winStreak,
      'ranking': ranking,
    });
  }
}
