import 'package:bookmarket/screens/books/book_sale_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class BookSaleEditItem extends StatelessWidget {
  const BookSaleEditItem({required this.book, Key? key}) : super(key: key);

  final BookItems book;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.scaffoldBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Buch anbieten',
          style: Styles.h1,
        ),
      ),
      child: SafeArea(
          child: BookSaleEditItemForm(
        book: book,
      )),
    );
  }
}

class BookSaleEditItemForm extends StatefulWidget {
  const BookSaleEditItemForm({required this.book, Key? key}) : super(key: key);

  final BookItems book;

  @override
  State<StatefulWidget> createState() {
    return SearchBookState();
  }
}

class SearchBookState extends State<BookSaleEditItemForm> {
  final _formKey = GlobalKey<FormState>();

  //Init firestore
  FirebaseFirestore fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    late String _isbn;
    late String _title;
    late String _coverImgURL = widget.book.coverImgURL;
    late String _author;
    late int _year;
    String _publisher = widget.book.publisher;
    late double _price;

    CollectionReference itemsRef = fire
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('library');

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
                    CupertinoFormRow(
                      prefix: const Text("ISBN"),
                      child: CupertinoTextFormFieldRow(
                        textAlign: TextAlign.end,
                        textInputAction: TextInputAction.next,
                        initialValue: widget.book.isbn.toString(),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
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
                        initialValue: widget.book.title,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
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
                        initialValue: widget.book.author,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
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
                        initialValue: widget.book.year.toString(),
                        keyboardType: TextInputType.datetime,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
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
                    CupertinoFormRow(
                      prefix: const Text("Preis"),
                      child: CupertinoTextFormFieldRow(
                        placeholder: "Preis eingeben",
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (preis) {
                          if (preis == null || preis.isEmpty) {
                            return "Bitte deinen Preis eingeben!";
                          } else if (double.tryParse(preis) == null) {
                            return " Bitte nur Zahlen eingeben!";
                          } else if (double.tryParse(preis)! < 0.0) {
                            return "Bitte nur positive Zahlen eingeben!";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _price = double.tryParse(value!)!;
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
                          _isbn,
                          _title,
                          _coverImgURL,
                          _author,
                          _publisher,
                          "1",
                          _year,
                          _price,
                          _price);

                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const BookSaleTab()),
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
}
