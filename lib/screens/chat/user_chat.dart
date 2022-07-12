import 'package:bookmarket/components/chat/chat_message.dart';
import 'package:bookmarket/models/chat_db.dart';
import 'package:bookmarket/service/firebase_api.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

//Init firestore
FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserChat extends StatefulWidget {
  const UserChat({required this.otherUid, Key? key}) : super(key: key);
  final String otherUid;

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  late String otherUid = widget.otherUid;
  String username = "";
  CollectionReference currentUserChatsRef = FirebaseApi.getChatsByUid(
      FirebaseAuth.instance.currentUser?.email.toString());
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // called on send-button pressed
  void _handleSubmitted(String text, String otherUsersEmail,
      CollectionReference otherUserChatRef) {
    _textController.clear();
    String? loggedinUser = FirebaseAuth.instance.currentUser?.email.toString();
    //Add Message to Firestore Collection for currentUser
    ChatItem.addMessage(currentUserChatsRef, loggedinUser!, otherUsersEmail,
        Timestamp.now(), text);
    //Add Message to Firestore Collection for otherUser
    ChatItem.addMessage(
        otherUserChatRef, loggedinUser, loggedinUser, Timestamp.now(), text);
    _focusNode.requestFocus();
  }

  //Textfield
  Widget _buildTextComposer(
      String otherUsersEmail, CollectionReference otherUserChatRef) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: CupertinoTextField(
              keyboardType: TextInputType.text,
              controller: _textController,
              placeholder: 'Nachricht...',
              cursorColor: Styles.accent1,
              focusNode: _focusNode,
            ),
          ),
          //Button for sending the Message
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0.2),
            child: CupertinoButton(
              onPressed: () => {
                if (_textController.text.isNotEmpty)
                  {
                    _handleSubmitted(
                        _textController.text, otherUsersEmail, otherUserChatRef)
                  }
              },
              child: const Icon(
                CupertinoIcons.arrow_up_circle_fill,
                color: Styles.accent1,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Prevent red error Message from Showing
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    List<ChatItem> messageList = [];
    //Firestore Structure: user / currentUser/ chats/otherUser / messages
    CollectionReference otherUserChatRef = FirebaseApi.getChatsByUid(otherUid);
    //Chat Reference for otherUser in the DB of the current User
    DocumentReference docRef = currentUserChatsRef.doc(otherUid);
    //single messages in docRef collection
    CollectionReference messRef = docRef.collection("messages");

    Timestamp messageDate = Timestamp.now();

    return CupertinoPageScaffold(
        backgroundColor: Styles.scaffoldBackground,
        // Navbar with Name of other User in the middle
        navigationBar: CupertinoNavigationBar(
          middle: FutureBuilder<String>(
              future: FirebaseApi().getUserInfo(otherUid),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                return Text(snapshot.data!, style: Styles.h2);
              }),
        ),

        //Get Messages from Chat
        child: StreamBuilder<QuerySnapshot>(
            stream: messRef.orderBy("timestamp", descending: true).snapshots(),
            builder: (BuildContext context, var messageSnapshots) {
              messageList = messageSnapshots.data!.docs
                  .map((messageData) => ChatItem.fromJson(
                      (messageData.data() as Map<String, dynamic>)
                        ..['id'] = messageData.id))
                  .where((e) => e != null)
                  .cast<ChatItem>()
                  .toList();

              //Show all messages in a scroll view
              return SafeArea(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                    child: CustomScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        shrinkWrap: false,
                        slivers: <Widget>[
                          SliverList(delegate:
                              SliverChildBuilderDelegate((context, index) {
                            if (index < messageList.length) {
                              if (DateFormat("dd.MM.").format(DateTime.parse(
                                      messageList[index]
                                          .timestamp
                                          .toDate()
                                          .toString())) ==
                                  DateFormat("dd.MM.").format(DateTime.parse(
                                      messageDate.toDate().toString()))) {
                                return ChatMessage(
                                  doc: messageList[index],
                                  newDate: false,
                                );
                              } else {
                                messageDate = messageList[index].timestamp;
                                return ChatMessage(
                                    doc: messageList[index], newDate: true);
                              }
                            }
                            return null;
                          }))
                        ]),
                  ),

                  //Textfield and Button for sending messages
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration:
                          const BoxDecoration(color: Styles.searchBackground),
                      child: _buildTextComposer(otherUid, otherUserChatRef),
                    ),
                  ),
                ]),
              );
            }));
  }
}
