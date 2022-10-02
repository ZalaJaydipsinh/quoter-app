import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuoteDatabaseService {
  final String uid;
  UserQuoteDatabaseService({required this.uid});

  //collection Reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future insertDummyUserData(String name) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'quote': FieldValue.arrayUnion([
        {
          "text": "Simplisity is also a fasion but everyone can't afford it.",
          "author": "APJ Abdul Kalam",
          "category": "life-style, favorite",
        }
      ]),
    });
  }
}
