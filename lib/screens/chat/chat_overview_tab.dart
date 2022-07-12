import 'package:bookmarket/components/chat/chat_overview_item.dart';
import 'package:bookmarket/models/chat_db.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//Init firestore
FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String currentUser = FirebaseAuth.instance.currentUser!.email.toString();
  List<ChatItem> chatsList = [];

  // Scrollview/Sliver which contains the list of chats
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Styles.scaffoldBackground,
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Chats',
            style: Styles.h1,
          ),
        ),
        //stream for chats
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("users")
                .doc(currentUser)
                .collection("chats")
                .snapshots(),
            builder: (BuildContext context, var chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting ||
                  !chatSnapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }

              List<String> uidList = [];

              //get chats and uid for every chat -> to save uids for sliverList
              final chats = chatSnapshot.data!.docs;
              for (var chat in chats) {
                Map<String, dynamic> chatMap =
                    chat.data() as Map<String, dynamic>;
                uidList.add(chatMap["uid"]);
              }

              if (uidList.isEmpty || chatSnapshot.data == null) {
                return const Center(
                  child: Text("Ganz schön einsam hier...",
                      style: Styles.standardText),
                );
              } else {
                //Builds Chat Items
                return SafeArea(
                  child: CustomScrollView(slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index < uidList.length) {
                          return ChatOverviewItem(
                              uid: uidList[index] //chats[index],
                          );
                        }
                        return null;
                      }),
                    )
                  ]),
                );
              }

            }));
  }
}
