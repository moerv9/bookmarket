import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import '../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

//models class to display a coverimage in custom upload of a book
//this model display the actual book cover and set functions to upload/delete a coverimage

class CoverUploadRow extends StatelessWidget {
  CoverUploadRow({
    required this.imageURL,
    this.imageFileName,
    required this.callbackFunction,
    Key? key,
  }) : super(key: key);

  //variables
  String imageURL;
  String? imageFileName;
  Function(String, String?) callbackFunction;

  late File _pickedImage;
  String defaultNoCover =
      "https://firebasestorage.googleapis.com/v0/b/bookmarket-999999.appspot.com/o/cover%2FnoCover.jpg?alt=media&token=0a81d966-7705-4a82-b59f-b361ec3d86ca";

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        prefix: CupertinoButton(
          // ignore: prefer_const_constructors
          child: Image.network(
            //Book Cover
            imageURL,
            fit: BoxFit.cover,
            height: 76,
          ),
          onPressed: () => _showActionSheet(context),
        ),
        child: CupertinoButton(
            child: Row(children: const [
              Expanded(
                  child: Text(
                "Coverbild ändern",
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
        title: const Text('Coverbild ändern'),
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
              //reset to default
              imageURL = defaultNoCover;
              //callback to transfer new imageURL to parent Widget and to redraw state
              callbackFunction(imageURL, null);

              //if there was a photo taken before -> delete in firestorage
              //if none -> only reset to default
              if (imageFileName != null) {
                //delete file on firebaseStorage
                final photoRef =
                    FirebaseStorage.instance.ref("cover/" + imageFileName!);
                await photoRef.delete();
              }
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
  // upload image to fire storage
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
      final String fileName = path.basename(pickedFile.path);

      _pickedImage = File(pickedFile.path);
      String imageUrl;

      //ref where the image should be stored
      Reference ref = FirebaseStorage.instance.ref("cover/" + fileName);

      //upload the image to firestorage
      UploadTask uploadTask = ref.putFile(_pickedImage);

      //when complete -> set imageUrl and imageFileName and start a callback to the parent widget (redraw the state)
      uploadTask.whenComplete(() async {
        imageUrl = await ref.getDownloadURL();
        logger.d(fileName);
        callbackFunction(imageUrl, fileName);
        imageURL = imageUrl;
        imageFileName = fileName;
      }).catchError((onError) {
        logger.d(onError);
      });
    } else {
      logger.d('Kein Bild ausgewählt');
    }
  }
}
