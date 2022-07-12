import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/cupertino_style.dart';

//https://www.kindacode.com/article/flutter-firebase-storage/

class RoundAvatar extends StatefulWidget {
  const RoundAvatar({
    required this.radius,
    required this.imageURL,
    required this.userName,
    Key? key,
  }) : super(key: key);

  final String imageURL;
  final String userName;
  final double radius;

  @override
  State<RoundAvatar> createState() => _RoundAvatarState();
}

class _RoundAvatarState extends State<RoundAvatar> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        currentUser = user; //reset the currentUser if, data has changed
      }
    });

    //control the current photoUrl and returns the right widget
    String? photoURL = widget.imageURL == ""
        ? currentUser!.photoURL
        : widget.imageURL != "notSet"
            ? widget.imageURL
            : null;
    var _image = photoURL != null
        ? (photoURL.contains('https://')
            ? NetworkImage(photoURL)
            : AssetImage(photoURL))
        : null; //empty Image to display Letter

    String userLetter = widget.userName == ""
        ? currentUser!.displayName.toString()[0].toUpperCase()
        : widget.userName.toString()[0].toUpperCase();

    return CircleAvatar(
      backgroundColor: Styles.accent1,
      backgroundImage: _image != null ? _image as ImageProvider : null,
      radius: widget.radius,
      child: photoURL == null
          ? Text(
              //if there is no photo -> background color + first letter in name
              userLetter,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.radius,
                  color: Styles.scaffoldBackground),
            )
          : const Text(
              ""), //empty Text to hide Letter when a image is available
    );
  }
}
