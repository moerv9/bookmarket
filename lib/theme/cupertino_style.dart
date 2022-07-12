import 'package:flutter/cupertino.dart';

abstract class Styles {
  //normal Text Style
  static const TextStyle standardText = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontFamily: 'Red Hat Text');

  //Header /Title of the page
  static const TextStyle h1 = TextStyle(
    color: Color.fromRGBO(177, 133, 219, 1),
    fontSize: 24,
    fontFamily: "Adamina",
    letterSpacing: 1,
  );

  //Title of Books
  static const TextStyle h2 = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20, fontFamily: "Gelasio");

  //Further description for Books under Book-Title -> Wishlist Tab
  static const TextStyle subtitleText = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle availableText = TextStyle(
    color: Color.fromARGB(255, 62, 62, 62),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  //Search Fields
  static const TextStyle searchText = TextStyle(
    color: Color.fromRGBO(125, 125, 125, 0.8),
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  //Style for label/description of Input Fields
  static const TextStyle valueDescription = TextStyle(
    color: Color(0xFFC2C2C2),
    fontWeight: FontWeight.w300,
  );

  //Apple Style Time & Date Picker
  static const TextStyle timePicker = TextStyle(
    color: CupertinoColors.inactiveGray,
  );

  static const TextStyle snackBar = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle messageSend = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontFamily: 'Red Hat Text');

  static const TextStyle messageRecv = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontFamily: 'Red Hat Text');

  static const TextStyle messageTime = TextStyle(
      color: CupertinoColors.black,
      fontFamily: "Red_Hat_Text",
      fontWeight: FontWeight.normal,
      fontSize: 10);

  static const TextStyle chatUser = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontSize: 16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontFamily: 'Red Hat Text');

  static const Color accent1 = Color.fromRGBO(177, 133, 219, 1);
  static const Color accent2 = Color.fromRGBO(230, 175, 46, 1);
  static const Color standardColor = CupertinoColors.black;

  static const Color divider = Color(0xFFD9D9D9);

  static const Color scaffoldBackground = Color(0xfff0f0f0);

  static const Color searchBackground =
      CupertinoColors.white; //Color(0xffe0e0e0);

  static const Color searchCursorColor = Color.fromRGBO(0, 122, 255, 1);

  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);

  static const Color delete = Color.fromRGBO(255, 0, 0, 1);
  static const Color mail = Color.fromRGBO(0, 174, 255, 1.0);
  static const Color edit = accent2;

  static const Color availableBackground = Color.fromRGBO(0, 255, 0, 0.10);
  static const Color availableButToExpensiveBackground =
      Color.fromRGBO(255, 177, 28, 0.10196078431372549);
}
