import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class BookItems {
  String uid;
  late String isbn;
  String title;
  String coverImgURL;
  String author;
  String publisher;
  String version;
  int year;
  double priceRLow;
  double priceRHigh;

  BookItems(this.uid, this.isbn, this.title, this.coverImgURL, this.author,
      this.publisher, this.version, this.year, this.priceRLow, this.priceRHigh);

  CollectionReference bookRef = FirebaseFirestore.instance.collection('books');

  static BookItems? fromJson(Map<String, dynamic> json) {
    try {
      BookItems book;
      book = BookItems(
          json["uid"],
          json["isbn"].toString(),
          json["title"],
          json["coverImgURL"],
          json["author"],
          json["publisher"],
          json["version"],
          json["year"],
          json["priceRLow"],
          json["priceRHigh"]);

      return book;
    } catch (e) {
      logger.d("Buch mit der ID:" +
          json["id"] +
          " ist falsch formatiert in der Datenbank");
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isbn": isbn,
        "title": title,
        "coverImgURL": coverImgURL,
        "author": author,
        "publisher": publisher,
        "version": version,
        "year": year,
        "priceRLow": priceRLow,
        "priceRHigh": priceRHigh,
      };

  static addItem(
    CollectionReference itemsRef,
    String uid,
    String isbn,
    String title,
    String coverImgURL,
    String author,
    String publisher,
    String version,
    int year,
    double priceRLow,
    double priceRHigh,
  ) async {
    final item = BookItems(
        "", isbn, title, coverImgURL, author, publisher, version, year, 0, 0);

    CollectionReference bookRef =
        FirebaseFirestore.instance.collection('books');

    //add isbn document to wishlist/library
    itemsRef.doc(item.isbn).set({
      "isbn": isbn,
      "priceRLow": priceRLow,
      "priceRHigh": priceRHigh,
      "uid": uid,
    });

    try {
      var doc = await bookRef.doc(isbn.toString()).get();

      if (!doc.exists) {
        bookRef.doc(item.isbn).set(item.toJson());
      }
    } catch (e) {
      logger.d(e.toString());
    }
  }

  static clone(BookItems book) {
    return BookItems(
        book.uid,
        book.isbn,
        book.title,
        book.coverImgURL,
        book.author,
        book.publisher,
        book.version,
        book.year,
        book.priceRLow,
        book.priceRHigh);
  }

  //Deletes Item
  static deleteItem(CollectionReference itemsRef, String isbn) {
    itemsRef.doc(isbn).delete();
  }

  @override
  String toString() {
    return 'BookItems{uid: $uid, isbn: $isbn, title: $title, coverImgURL: $coverImgURL, author: $author, publisher: $publisher, version: $version, year: $year, price: $priceRLow - $priceRHigh}';
  }
}
