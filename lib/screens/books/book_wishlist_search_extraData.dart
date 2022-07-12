import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';
import 'book_wishlist_tab.dart';

class BookWishlistSearchExtraData extends StatefulWidget {
  const BookWishlistSearchExtraData({required this.book, Key? key})
      : super(key: key);

  final BookItems book; //get the book from the api list

  @override
  State<StatefulWidget> createState() {
    return SearchBookState();
  }
}

class SearchBookState extends State<BookWishlistSearchExtraData> {
  final _formKey = GlobalKey<FormState>();

  //Init firestore
  FirebaseFirestore fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    late double _priceRLow;
    late double _priceRHigh;
    double? _priceLowContr;
    double? _priceHighContr;

    CollectionReference itemsRef = fire
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('wishlist');

    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Buch suchen',
          style: Styles.h1,
        ),
      ),
      child: SafeArea(
          child: Padding(
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
                      CupertinoFormRow(
                        prefix: const Text("Titel"),
                        child: CupertinoTextFormFieldRow(
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.end,
                          initialValue: widget.book.title,
                          readOnly: true,
                        ),
                      ),
                    ]),
                CupertinoFormSection(
                    header: const Text("Dein Wunschpreis"),
                    children: [
                      CupertinoFormRow(
                        prefix: const Text("von"),
                        child: CupertinoTextFormFieldRow(
                          //placeholder: "Preis eingeben",
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (preis) {
                            if (preis == null || preis.isEmpty) {
                              return "Bitte deinen Mindestpreis eingeben!";
                            } else if (double.tryParse(preis) == null) {
                              return "Bitte nur Zahlen eingeben!";
                            } else if (double.tryParse(preis)! < 0.0) {
                              return "Bitte nur positive Zahlen eingeben!";
                            } else if (_priceHighContr != null &&
                                (double.tryParse(preis)! > _priceHighContr!)) {
                              return "Diese Zahl muss kleiner sein als der unten stehende Höchstpreis!";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            if (value != "") {
                              _priceLowContr = double.tryParse(value)!;
                            } else {
                              _priceLowContr = null;
                            }
                          },
                          onSaved: (value) {
                            _priceRLow = double.tryParse(value!)!;
                          },
                        ),
                      ),
                      CupertinoFormRow(
                        prefix: const Text("bis"),
                        child: CupertinoTextFormFieldRow(
                          //placeholder: "Preis eingeben",
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (preis) {
                            if (preis == null || preis.isEmpty) {
                              return "Bitte deinen Höchstpreis eingeben!";
                            } else if (double.tryParse(preis) == null) {
                              return "Bitte nur Zahlen eingeben!";
                            } else if (double.tryParse(preis)! < 0.0) {
                              return "Bitte nur positive Zahlen eingeben!";
                            } else if (_priceLowContr != null &&
                                (double.tryParse(preis)! < _priceLowContr!)) {
                              return "Diese Zahl muss größer sein als der oben stehende Mindestpreis!";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            if (value != "") {
                              _priceHighContr = double.tryParse(value)!;
                            } else {
                              _priceHighContr = null;
                            }
                          },
                          onSaved: (value) {
                            _priceRHigh = double.tryParse(value!)!;
                          },
                        ),
                      ),
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
                            widget.book.isbn,
                            widget.book.title,
                            widget.book.coverImgURL,
                            widget.book.author,
                            widget.book.publisher,
                            widget.book.version,
                            widget.book.year,
                            _priceRLow,
                            _priceRHigh);

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
      )),
    );
  }
}
