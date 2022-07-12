import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class ProfileEditUserInfoFirebase extends StatefulWidget {
  const ProfileEditUserInfoFirebase(
      {required this.title,
      required this.docRef,
      required this.actualValue,
      required this.dataTitle,
      Key? key})
      : super(key: key);

  final String title;
  final DocumentReference docRef;
  final String dataTitle;
  final String actualValue;

  @override
  State<ProfileEditUserInfoFirebase> createState() {
    return _ProfileEditUserInfoFirebaseState();
  }
}

class _ProfileEditUserInfoFirebaseState
    extends State<ProfileEditUserInfoFirebase> {
  final _foreignKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.title + " ändern",
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
                          prefix: Text(widget.title),
                          child: CupertinoTextFormFieldRow(
                            textAlign: TextAlign.end,
                            textInputAction: TextInputAction.next,
                            placeholder: widget.actualValue,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte " + widget.title + " eingeben!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) async {
                              widget.docRef.update({
                                widget.dataTitle.toLowerCase(): value,
                              });
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
