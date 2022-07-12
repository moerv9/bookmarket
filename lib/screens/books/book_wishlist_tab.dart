import 'package:bookmarket/components/listviews/whishlist_row_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';
import 'book_wishlist_search.dart';

class BookWishlistTab extends StatefulWidget {
  const BookWishlistTab({Key? key}) : super(key: key);

  @override
  State<BookWishlistTab> createState() => _BookWhishlistState();
}

class _BookWhishlistState extends State<BookWishlistTab> {
  //Init firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference bookWishlistRef = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('wishlist');

    CollectionReference bookRef = firestore.collection('books');

    List<BookItems> wishlistBooks = [];
    List<BookItems> saleBookList = [];

    return CupertinoPageScaffold(
        backgroundColor: Styles.scaffoldBackground,
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Wunschliste',
            style: Styles.h1,
          ),
          trailing: CupertinoButton(
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const BookWishlistSearch())),
            child: const Icon(
              CupertinoIcons.add,
              semanticLabel: "add",
              color: Styles.accent1,
            ), //icon inside button
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: bookWishlistRef.snapshots(),
            builder: (BuildContext context, var wishlistSnapshot) {
              if (wishlistSnapshot.connectionState == ConnectionState.waiting ||
                  !wishlistSnapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }
              List<QueryDocumentSnapshot<Object?>> wishlist =
                  wishlistSnapshot.data!.docs;

              if (wishlist.isEmpty || wishlistSnapshot.data == null) {
                return const Center(
                  child: Text("Ganz schön leer hier...",
                      style: Styles.standardText),
                );
              }

              //second nested streambuilder to check changes on all libraries in the app
              return StreamBuilder<QuerySnapshot>(
                  stream: firestore.collectionGroup("library").snapshots(),
                  builder: (BuildContext context, var saleBooksSnapshot) {
                    if (saleBooksSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        !saleBooksSnapshot.hasData) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    List<QueryDocumentSnapshot<Object?>> salelist =
                        saleBooksSnapshot.data!.docs;

                    //third nested streambuilder to get all books in database
                    return StreamBuilder<QuerySnapshot>(
                        stream: bookRef.snapshots(),
                        builder: (BuildContext context, var bookSnapshot) {
                          if (bookSnapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !bookSnapshot.hasData) {
                            return const Center(
                                child: CupertinoActivityIndicator());
                          }

                          //create a booklist of all books, that are saved in our database list
                          List<BookItems> booklist = bookSnapshot.data!.docs
                              .map((doc) => BookItems.fromJson(
                                  (doc.data() as Map<String, dynamic>)))
                              .where((e) => e != null) //<--remove nulls
                              .cast<BookItems>()
                              .toList();

                          wishlistBooks = []; //reset the list
                          //fill the list with each element, that is in our booklist
                          //the book data should be allways there, because when you are creating a book with an unknown isbn it will be saved in that database
                          // ignore: avoid_function_literals_in_foreach_calls
                          wishlist.forEach((element) async {
                            Map<String, dynamic> wishlistMap =
                                element.data() as Map<String, dynamic>;

                            for (var book in booklist) {
                              if (book.isbn == wishlistMap['isbn']) {
                                BookItems correctBook = BookItems.clone(
                                    book); //clone Object to edit some values without editing the original version in booklist
                                correctBook.uid = wishlistMap[
                                    "uid"]; //the user id of the own user
                                correctBook.priceRLow = wishlistMap[
                                    "priceRLow"]; //price range: low end - cheapest price the buyer would buy it
                                correctBook.priceRHigh = wishlistMap[
                                    "priceRHigh"]; //price range: high end - most expensive price the buyer would buy it
                                wishlistBooks.add(correctBook);
                              }
                            }
                          });

                          saleBookList = []; //reset the list
                          //fill the list with each element, that is in our booklist
                          //saleBookList hold all books that are sold in the app -> easier to get contact data
                          // ignore: avoid_function_literals_in_foreach_calls
                          salelist.forEach((element) async {
                            Map<String, dynamic> salelistMap =
                                element.data() as Map<String, dynamic>;

                            for (var book in booklist) {
                              if (book.isbn == salelistMap['isbn']) {
                                BookItems correctBook = BookItems.clone(book);
                                correctBook.uid = salelistMap[
                                    "uid"]; //the user id of the seller user
                                correctBook.priceRLow = salelistMap[
                                    "priceRLow"]; //price range: low end - cheapest price the seller would sell it
                                correctBook.priceRHigh = salelistMap[
                                    "priceRHigh"]; //price range: high end - most expensive price the seller would sell it
                                saleBookList.add(correctBook);
                              }
                            }
                          });

                          return SafeArea(
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (index < wishlistBooks.length) {
                                        //function to check if a book on the wishlist is in someones library
                                        //check by compare the isbn
                                        //default => false
                                        List<BookItems> matchingBooks = [];

                                        // print("SalebookList: " +
                                        //     saleBookList.toString());

                                        for (var saleBook in saleBookList) {
                                          if ((saleBook.isbn ==
                                                  wishlistBooks[index].isbn) &&
                                              saleBook.uid !=
                                                  FirebaseAuth.instance
                                                      .currentUser?.email
                                                      .toString()) {
                                            matchingBooks.add(saleBook);
                                            logger.d("verfügbare Bücher: " +
                                                matchingBooks.toString());
                                          }
                                        }
                                        matchingBooks.sort((a, b) =>
                                            a.priceRLow.compareTo(b.priceRLow));
                                        return WishlistRowItem(
                                          book: wishlistBooks[index],
                                          lastItem:
                                              index == wishlistBooks.length - 1,
                                          itemsref: bookWishlistRef,
                                          availableBooks: matchingBooks,
                                        );
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  });
            }));
  }
}
