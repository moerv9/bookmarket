import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class ProfileEditPassword extends StatefulWidget {
  const ProfileEditPassword({Key? key}) : super(key: key);

  @override
  State<ProfileEditPassword> createState() {
    return _ProfileEditPasswordState();
  }
}

class _ProfileEditPasswordState extends State<ProfileEditPassword> {
  final _foreignKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  //Init firebase auth
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = firebaseAuth.currentUser;

    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Passwort ändern",
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
                          prefix: const Text("Passwort"),
                          child: CupertinoTextFormFieldRow(
                            textAlign: TextAlign.end,
                            textInputAction: TextInputAction.next,
                            controller: _pass,
                            placeholder: "Bitte neues Passwort eingeben",
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte ein Passwort eingeben!";
                              } else if (value.length < 6) {
                                return "Mindestens 6 Zeichen eingeben!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) async {
                              logger.d(value.toString());
                              user!.updatePassword(value.toString());
                            },
                          ),
                        ),
                        CupertinoFormRow(
                          prefix: const Text("Passwort bestätigen"),
                          child: CupertinoTextFormFieldRow(
                            textAlign: TextAlign.end,
                            controller: _confirmPass,
                            placeholder: "Bitte neues Passwort bestätigen",
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte das Passwort bestätigen!';
                              }
                              if (value != _pass.text) {
                                return 'Passwort stimmt nicht überein';
                              }
                              return null;
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
