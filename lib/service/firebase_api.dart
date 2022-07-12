import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static getChatsByUid(String? userIdentifier) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userIdentifier)
        .collection('chats');
  }

  Future<String> getUserInfo(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        //.where("username", isEqualTo: username)
        .get();
    Map<String, dynamic>? data = snapshot.data();
    return data!["username"];
  }
}
