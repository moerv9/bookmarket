import 'package:bookmarket/screens/books/book_wishlist_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../components/cover_upload_row.dart';
import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class WishlistAddItem extends StatelessWidget {
  const WishlistAddItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Buch suchen',
          style: Styles.h1,
        ),
      ),
      child: SafeArea(child: WishlistAddItemForm()),
    );
  }
}

class WishlistAddItemForm extends StatefulWidget {
  const WishlistAddItemForm({Key? key}) : super(key: key);

  @override
  State<WishlistAddItemForm> createState() => _WishlistAddItemFormState();
}

class _WishlistAddItemFormState extends State<WishlistAddItemForm> {
  final _formKey = GlobalKey<FormState>();

  //Init firestore
  FirebaseFirestore fire = FirebaseFirestore.instance;

  String _coverImg =
      "https://firebasestorage.googleapis.com/v0/b/bookmarket-999999.appspot.com/o/cover%2FnoCover.jpg?alt=media&token=0a81d966-7705-4a82-b59f-b361ec3d86ca";
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    late String _isbn;
    late String _title;
    late String _author;
    late String _version;
    late int _year;
    String _publisher = "Publisher";
    late double _priceHigh;
    late double _priceLow;
    double? _priceLowControl;
    double? _priceHighControl;

    CollectionReference itemsRef = fire
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('wishlist');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
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
                    CoverUploadRow(
                        imageFileName: _fileName,
                        imageURL: _coverImg,
                        callbackFunction: callbackImageURLUpdate),
                    CupertinoFormRow(
                      prefix: const Text("ISBN"),
                      child: CupertinoTextFormFieldRow(
                        textAlign: TextAlign.end,
                        textInputAction: TextInputAction.next,
                        placeholder: "ISBN eingeben",
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (isbn) {
                          if (isbn == null || isbn.isEmpty) {
                            return "Bitte eine ISBN eingeben!";
                          } else if (int.tryParse(isbn) == null) {
                            return " Bitte nur Zahlen eingeben!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _isbn = value!;
                        },
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: const Text("Titel"),
                      child: CupertinoTextFormFieldRow(
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.end,
                        //placeholder: "Titel eingeben",
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (isbn) {
                          if (isbn == null || isbn.isEmpty) {
                            return "Bitte den Titel eingeben!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _title = value!;
                        },
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: const Text("Autor*in"),
                      child: CupertinoTextFormFieldRow(
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        //placeholder: "Autor eingeben",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (isbn) {
                          if (isbn == null || isbn.isEmpty) {
                            return "Bitte den Autor eingeben!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _author = value!;
                        },
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: const Text("Erscheinungsjahr"),
                      child: CupertinoTextFormFieldRow(
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.end,
                        //placeholder: "Erscheinungsjahr eingeben",
                        keyboardType: TextInputType.datetime,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (isbn) {
                          if (isbn == null || isbn.isEmpty) {
                            return "Bitte das Erscheinungsjahr eingeben!";
                          } else if (int.tryParse(isbn) == null) {
                            return " Bitte nur Zahlen eingeben!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _year = int.tryParse(value!)!;
                        },
                      ),
                    ),
                    CupertinoFormSection(
                        header: const Text("Dein Wunschpreis: "),
                        children: [
                          CupertinoFormRow(
                            prefix: const Text("von"),
                            child: CupertinoTextFormFieldRow(
                              //placeholder: "Preis eingeben",
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (preis) {
                                if (preis == null || preis.isEmpty) {
                                  return "Bitte deinen Mindestpreis eingeben!";
                                } else if (double.tryParse(preis) == null) {
                                  return "Bitte nur Zahlen eingeben!";
                                } else if (double.tryParse(preis)! < 0.0) {
                                  return "Bitte nur positive Zahlen eingeben!";
                                } else if (_priceHighControl != null &&
                                    (double.tryParse(preis)! >
                                        _priceHighControl!)) {
                                  return "Diese Zahl muss kleiner sein als der unten stehende Höchstpreis!";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value != "") {
                                  _priceLowControl = double.tryParse(value)!;
                                } else {
                                  _priceLowControl = null;
                                }
                              },
                              onSaved: (value) {
                                _priceLow = double.tryParse(value!)!;
                              },
                            ),
                          ),
                          CupertinoFormRow(
                            prefix: const Text("bis"),
                            child: CupertinoTextFormFieldRow(
                              //placeholder: "Preis eingeben",
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (preis) {
                                if (preis == null || preis.isEmpty) {
                                  return "Bitte deinen Höchstpreis eingeben!";
                                } else if (double.tryParse(preis) == null) {
                                  return "Bitte nur Zahlen eingeben!";
                                } else if (double.tryParse(preis)! < 0.0) {
                                  return "Bitte nur positive Zahlen eingeben!";
                                } else if (_priceLowControl != null &&
                                    (double.tryParse(preis)! <
                                        _priceLowControl!)) {
                                  return "Diese Zahl muss größer sein als der oben stehende Mindestpreis!";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value != "") {
                                  _priceHighControl = double.tryParse(value)!;
                                } else {
                                  _priceHighControl = null;
                                }
                              },
                              onSaved: (value) {
                                _priceHigh = double.tryParse(value!)!;
                              },
                            ),
                          ),
                        ])
                  ]),
              const SizedBox(height: 20),
              CupertinoButton(
                  child: const Text("Hinzufügen"),
                  color: Styles.accent1,
                  onPressed: () {
                    final form = _formKey.currentState!;

                    if (form.validate()) {
                      form.save();
                      String userName =
                          FirebaseAuth.instance.currentUser!.email.toString();
                      BookItems.addItem(
                          itemsRef,
                          userName,
                          _isbn,
                          _title,
                          _coverImg,
                          _author,
                          _publisher,
                          "1",
                          _year,
                          _priceLow,
                          _priceHigh);

                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const BookWishlistTab()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      CupertinoAlertDialog(
                          title: const Text("Warnung"),
                          content: const Text("Fehler bei der Eingabe "),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                      logger.d("Angaben in der Form sind nicht richtig");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  callbackImageURLUpdate(String imageUrl, String? fileName) {
    setState(() {
      _coverImg = imageUrl;
      _fileName = fileName;
    });
  }
}
