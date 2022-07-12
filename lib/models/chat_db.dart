import 'package:bookmarket/service/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class ChatItem {
  late String id;
  late String uid;
  late Timestamp timestamp;
  late String message;

  ChatItem(this.uid, this.timestamp, this.message);

  static ChatItem? fromJson(Map<String, dynamic> json) {
    try {
      ChatItem chatItem =
          ChatItem(json["uid"], json["timestamp"], json["message"]);
      chatItem.id = json["id"];
      return chatItem;
    } on Exception catch (e) {
      logger.d(e);
      return null;
    }
  }

  Map<String, dynamic> toJson() =>
      {"uid": uid, "timestamp": timestamp, "message": message};

  static addMessage(
    CollectionReference colRef,
    String uid,
    String otherUid,
    Timestamp timestamp,
    String message,
  ) async {
    final item = ChatItem(uid, timestamp, message);
    DocumentReference docRef = colRef.doc(otherUid);
    CollectionReference messRef = docRef.collection("messages");
    String data = await FirebaseApi().getUserInfo(otherUid);
    colRef.doc(docRef.id).update({"lastMessageAt": DateTime.now()});
    colRef.doc(docRef.id).set({"uid": otherUid, "username": data});
    messRef.add(item.toJson());
  }

  static deleteChat(DocumentReference docRef) {
    docRef.delete();
  }
}
