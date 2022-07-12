import 'dart:io';

import 'package:bookmarket/components/round_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

//models class to display a row item in profile page
//this model display the actual avatar and set functions to change the avatar

class ProfileAvatarRowItem extends StatefulWidget {
  const ProfileAvatarRowItem({
    required this.currentUser,
    required this.docRef,
    Key? key,
  }) : super(key: key);

  final DocumentReference docRef;
  final User currentUser;

  @override
  State<ProfileAvatarRowItem> createState() => _ProfileAvatarRowItemState();
}

class _ProfileAvatarRowItemState extends State<ProfileAvatarRowItem> {
  late File _pickedImage;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        prefix: CupertinoButton(
          // ignore: prefer_const_constructors
          child: RoundAvatar(radius: 50, imageURL: "", userName: ""),
          onPressed: () => _showActionSheet(context),
        ),
        child: CupertinoButton(
            child: Row(children: const [
              Expanded(
                  child: Text(
                "Profilbild ändern",
                style: Styles.standardText,
              )),
              Icon(
                CupertinoIcons.chevron_right,
                color: Colors.grey,
                size: 25.0,
              )
            ]),
            onPressed: () => _showActionSheet(context)));
  }

  //popup module
  // This shows the CupertinoModalPopup with a CupertinoActionSheet.
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Profilbild ändern'),
        //message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(true); //true -> get Image from gallery

              //close the actionSheet
              Navigator.pop(context);
            },
            child: const Text('Fotos'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              _getImage(false); //false -> get Image with camera

              //close the actionSheet
              Navigator.pop(context);
            },
            child: const Text('Bild aufnehmen'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              //set firebaseAuth photoURL to null
              widget.currentUser.updatePhotoURL(null);

              //delete firebase database photoURL of user
              widget.docRef.update({
                "photoURL": FieldValue.delete(),
              });

              //delete file on firebaseStorage
              final photoRef = FirebaseStorage.instance
                  .ref("avatar/" + widget.currentUser.uid.toString());
              await photoRef.delete();

              //close the actionSheet
              Navigator.pop(context);
            },
            child: const Text('Bild löschen'),
          ),
        ],

        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            //close the actionSheet
            Navigator.pop(context);
          },
          child: const Text('Abbrechen'),
        ),
      ),
    );
  }

  //Image Picker function (library and camera)
  // upload image to firebase and set links in database
  Future _getImage(bool gallery) async {
    ImagePicker _picker = ImagePicker();
    XFile? pickedFile;

    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
    }

    // Otherwise open camera to get new photo
    else {
      pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      final String fileName = widget.currentUser.uid
          .toString(); //filename = userID  (other version: original image name: path.basename(pickedFile.path) )

      _pickedImage = File(pickedFile.path);
      String imageUrl;

      //ref where the image should be stored
      Reference ref = FirebaseStorage.instance.ref("avatar/" + fileName);

      //upload the image to firestore with metadata
      UploadTask uploadTask = ref.putFile(
          _pickedImage,
          SettableMetadata(customMetadata: {
            'avatar_of': widget.currentUser.uid,
          }));

      //when complete -> set imageUrl to currentUser
      uploadTask.whenComplete(() async {
        imageUrl = await ref.getDownloadURL();
        widget.currentUser.updatePhotoURL(imageUrl);
        widget.docRef.update({
          "photoURL": imageUrl,
        });
      }).catchError((onError) {
        logger.d(onError);
      });
    } else {
      logger.d('Kein Bild ausgewählt');
    }
  }
}
