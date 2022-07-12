import 'package:bookmarket/components/round_avatar.dart';
import 'package:bookmarket/models/chat_db.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// Chat Message Class, each message displayed is an instance of this class
class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.doc,
    required this.newDate,
    Key? key,
  }) : super(key: key);
  final ChatItem doc;
  final bool newDate;

  @override
  Widget build(BuildContext context) {
    // if message is from logged in user, display to the right of screen
    if (doc.uid == FirebaseAuth.instance.currentUser?.email.toString()) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            /*if (newDate)
              Text(DateFormat("dd.MM.")
                  .format(DateTime.parse(doc.timestamp.toDate().toString()))),*/
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //message
                    Container(
                      decoration: const BoxDecoration(
                          color: Styles.accent1,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10.00),
                      margin: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        doc.message,
                        style: Styles.messageSend,
                      ),
                    ),
                    //timestamp of message
                    Container(
                      padding: const EdgeInsets.only(top: 5, right: 5),
                      child: Text(
                        DateFormat("dd.MM. hh:mm").format(
                            DateTime.parse(doc.timestamp.toDate().toString())),
                        style: Styles.messageTime,
                      ),
                    )
                  ],
                ),
              ),
              //image
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: RoundAvatar(radius: 22, imageURL: "", userName: ""),
              )
            ]),
          ],
        ),
      );
    } else {
      // If message is not from logged in user, display to left of screen
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(doc.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          String photoURL;
          String userName;

          try {
            photoURL = userSnapshot.data?["photoURL"];
          } catch (e) {
            photoURL = "notSet";
          }

          try {
            userName = userSnapshot.data?["username"];
          } catch (e) {
            userName = "User";
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //image
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                  child: RoundAvatar(
                      radius: 22, imageURL: photoURL, userName: userName),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //message
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(
                                    10))), //all(Radius.circular(15)),
                        margin: const EdgeInsets.only(top: 5.0),
                        padding: const EdgeInsets.all(10.00),
                        child: Text(
                          doc.message,
                          style: Styles.messageRecv,
                        ),
                      ),
                      //timestamp
                      Container(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Text(
                          doc.timestamp.toDate().toString().substring(10, 16),
                          style: Styles.messageTime,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
