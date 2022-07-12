import 'package:bookmarket/components/round_avatar.dart';
import 'package:bookmarket/screens/chat/user_chat.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class ChatOverviewItem extends StatelessWidget {
  const ChatOverviewItem({
    required this.uid,
    Key? key,
  }) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    //on click go to Chat with User uid
    final row = GestureDetector(
        onTap: (() => {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    settings: RouteSettings(arguments: uid),
                    builder: (context) => UserChat(
                      otherUid: uid,
                    ),
                  ))
            }),
        child: Slidable(
          child: SafeArea(
            top: false,
            bottom: false,
            minimum:
                const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            child: Stack(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
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

                    return Row(
                      children: <Widget>[
                        //profile image
                        RoundAvatar(
                            radius: 22, imageURL: photoURL, userName: userName),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //gets the Username
                              Text(userName, style: Styles.h2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    //gets Last Message
                                    child: FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        future: firestore
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.email
                                                .toString())
                                            .collection("chats")
                                            .doc(uid)
                                            .collection("messages")
                                            .orderBy("timestamp")
                                            .get(),
                                        builder: (BuildContext context,
                                            var snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              !snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CupertinoActivityIndicator());
                                          }
                                          var data =
                                              snapshot.data!.docs.last.data();
                                          return Text(data["message"],
                                              style: Styles.standardText,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false);
                                        }),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    //gets timestamp for last message
                                    child: FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        future: firestore
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.email
                                                .toString())
                                            .collection("chats")
                                            .doc(uid)
                                            .collection("messages")
                                            .orderBy("timestamp")
                                            .get(),
                                        builder: (BuildContext context,
                                            var snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              !snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CupertinoActivityIndicator());
                                          }
                                          var data =
                                              snapshot.data!.docs.last.data();
                                          return Text(
                                              data["timestamp"]
                                                  .toDate()
                                                  .toString()
                                                  .substring(10, 16),
                                              style: Styles.subtitleText,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false);
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          //deletes the chat for currentUser with other user uid from firestore
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  firestore
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser?.email.toString())
                      .collection("chats")
                      .doc(uid)
                      .delete()
                      .then(
                        (value) => logger.d("Chat for $uid deleted"),
                      );
                },
                backgroundColor: Styles.delete,
                foregroundColor: Styles.scaffoldBackground,
                icon: CupertinoIcons.xmark_circle,
                label: 'Löschen',
              )
            ],
          ),
        ));
    return Column(
      children: <Widget>[
        row,
        //divider between chats
        Padding(
          padding: const EdgeInsets.only(left: 77, right: 16),
          child: Container(
            height: 1,
            color: Styles.divider,
          ),
        ),
      ],
    );
  }
}
