import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class ProfileEditUsername extends StatefulWidget {
  const ProfileEditUsername({Key? key}) : super(key: key);

  @override
  State<ProfileEditUsername> createState() {
    return _ProfileEditUsernameState();
  }
}

class _ProfileEditUsernameState extends State<ProfileEditUsername> {
  final _foreignKey = GlobalKey<FormState>();

  //Init firebase auth
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Init firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = firebaseAuth.currentUser;

    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Nutzernamen ändern",
          style: Styles.h1,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _foreignKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CupertinoFormSection(
                      decoration: BoxDecoration(
                        color: Styles.searchBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      children: [
                        CupertinoFormRow(
                          prefix: const Text("Nutzername"),
                          child: CupertinoTextFormFieldRow(
                            textAlign: TextAlign.end,
                            textInputAction: TextInputAction.next,
                            placeholder: user?.displayName.toString(),
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte einen Nutzernamen eingeben!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) async {
                              user!.updateDisplayName(value.toString());
                              firestore
                                  .collection('users')
                                  .doc(user.email)
                                  .update({"username": value.toString()});
                            },
                          ),
                        ),
                      ]),
                  const SizedBox(height: 20),
                  CupertinoButton(
                      child: const Text("Ändern"),
                      color: Styles.accent1,
                      onPressed: () {
                        final form = _foreignKey.currentState!;

                        if (form.validate()) {
                          logger.d("Alles richtig");
                          form.save();

                          Navigator.pop(context);
                        } else {
                          logger.d("Da ist noch was nicht richtig");
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
