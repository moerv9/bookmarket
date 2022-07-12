import 'package:bookmarket/components/profile/profile_avatar_row_item.dart';
import 'package:bookmarket/components/profile/profile_setting_text_row_item.dart';
import 'package:bookmarket/screens/profile_edit/profile_edit_password.dart';
import 'package:bookmarket/screens/profile_edit/profile_edit_user_info_firebase.dart';
import 'package:bookmarket/screens/profile_edit/profile_edit_username.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/authentication.dart';
import "../theme/cupertino_style.dart";
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'login_tab.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => HomePage();
}

class HomePage extends State<ProfileTab> {
  //Init firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Init firebase auth
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User currentUser = firebaseAuth.currentUser!;

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        currentUser = user; //reset the currentUser if, data has changed
      }
    });

    //ref to the userDocument in Firestore
    DocumentReference docUserRef =
        firestore.collection("users").doc(currentUser.email.toString());

    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
          middle: Text(
        'Profil',
        style: Styles.h1,
      )),
      child: Consumer<ApplicationState>(
        builder: (context, user, child) {
          // ignore: unnecessary_null_comparison
          if (currentUser != null) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(children: [
                  CupertinoFormSection(
                      header: const Text("Account"),
                      children: [
                        ProfileAvatarRowItem(
                          currentUser: currentUser,
                          docRef: docUserRef,
                        ),
                        ProfileSettingTextRowItem(
                            title: "Benutzername ändern",
                            icon: CupertinoIcons.person_fill,
                            value: currentUser.displayName.toString(),
                            fillEmptyData: false,
                            editFormPage: const ProfileEditUsername()),
                        const ProfileSettingTextRowItem(
                            title: "Passwort ändern",
                            icon: CupertinoIcons.lock_fill,
                            value: "",
                            fillEmptyData: false,
                            editFormPage: ProfileEditPassword()),
                      ]),
                  StreamBuilder(
                    stream: firestore
                        .collection("users")
                        .doc(currentUser.email.toString())
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                      String universityData;
                      String courseData;
                      String cityData;

                      try {
                        universityData = userSnapshot.data?["university"];
                      } catch (e) {
                        universityData = "(noch nicht angegeben)";
                      }

                      try {
                        courseData = userSnapshot.data?["course"];
                      } catch (e) {
                        courseData = "(noch nicht angegeben)";
                      }

                      try {
                        cityData = userSnapshot.data?["city"];
                      } catch (e) {
                        cityData = "(noch nicht angegeben)";
                      }

                      return CupertinoFormSection(
                          header: const Text("Studieninformationen"),
                          children: [
                            ProfileSettingTextRowItem(
                                title: "Hochschule",
                                icon: Icons.school,
                                value: universityData,
                                fillEmptyData: true,
                                editFormPage: ProfileEditUserInfoFirebase(
                                  title: "Hochschule",
                                  docRef: docUserRef,
                                  actualValue: universityData,
                                  dataTitle: 'university',
                                )),
                            ProfileSettingTextRowItem(
                                title: "Studiengang",
                                icon: Icons.school,
                                value: courseData,
                                fillEmptyData: true,
                                editFormPage: ProfileEditUserInfoFirebase(
                                  title: "Studiengang",
                                  docRef: docUserRef,
                                  actualValue: courseData,
                                  dataTitle: 'course',
                                )),
                            ProfileSettingTextRowItem(
                                title: "Wohnort",
                                icon: Icons.school,
                                value: cityData,
                                fillEmptyData: true,
                                editFormPage: ProfileEditUserInfoFirebase(
                                  title: "Wohnort",
                                  docRef: docUserRef,
                                  actualValue: cityData,
                                  dataTitle: 'city',
                                )),
                          ]);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Consumer<ApplicationState>(
                      builder: (context, appState, _) => Authentication(
                        email: appState.email,
                        loginState: appState.loginState,
                        startLoginFlow: appState.startLoginFlow,
                        verifyEmail: appState.verifyEmail,
                        signInWithEmailAndPassword:
                            appState.signInWithEmailAndPassword,
                        cancelRegistration: appState.cancelRegistration,
                        registerAccount: appState.registerAccount,
                        signOut: appState.signOut,
                      ),
                    ),
                  )
                ]),
              ),
            );
          } else {
            return const Text('Benutzerabfrage funktioniert nicht');
          }
        },
      ),
    );
  }
}
