import 'package:bookmarket/components/listviews/wishlist_search_row_item.dart';
import 'package:bookmarket/screens/books/book_wishlist_add_item.dart';
import 'package:bookmarket/service/api_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class BookWishlistSearch extends StatelessWidget {
  const BookWishlistSearch({Key? key}) : super(key: key);

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
      child: SafeArea(child: BookWishlistSearchForm()),
    );
  }
}

class BookWishlistSearchForm extends StatefulWidget {
  const BookWishlistSearchForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchBookState();
  }
}

class SearchBookState extends State<BookWishlistSearchForm> {
  //Init firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  APIcall api = APIcall();

  late CollectionReference booksRef = firestore.collection('books');

  List<BookItems> _allLocalBooks = [];

  List<BookItems> _foundBooks = [];

  String _searchTerm = "";

  @override
  void initState() {
    _foundBooks = _allLocalBooks;
    super.initState();
  }

  Future<void> _runSearch(String searchTerm) async {
    List<BookItems> results = [];
    if (searchTerm.isNotEmpty) {
      results = _allLocalBooks
          .where((book) =>
              book.title.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    if (searchTerm.length > 4) {
      results += await api.fetchBooks(searchTerm);
    }

    setState(() {
      _foundBooks = results;
      _searchTerm = searchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference whishListRef = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('wishlist');

    List<BookItems> saleBookList = [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CupertinoSearchTextField(
            onChanged: (value) => _runSearch(value),
            onSubmitted: (value) => _runSearch(value),
            placeholder: "Suche",
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: booksRef.snapshots(),
            builder: (BuildContext context, var booksSnapshot) {
              if (booksSnapshot.connectionState == ConnectionState.waiting ||
                  !booksSnapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }

              //create a booklist of all books, that are saved in our database list
              List<BookItems> booklist = booksSnapshot.data!.docs
                  .map((doc) =>
                      BookItems.fromJson((doc.data() as Map<String, dynamic>)))
                  .where((e) => e != null) //<--remove nulls
                  .cast<BookItems>()
                  .toList();
              _allLocalBooks = booklist;
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

                    return Expanded(
                        child: _foundBooks.isNotEmpty
                            ? SafeArea(
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          if (index < _foundBooks.length) {
                                            //function to check if a book on the wishlist is in someones library
                                            //check by compare the isbn
                                            //default => false
                                            List<BookItems> matchingSaleBooks =
                                                [];

                                            for (var saleBook in saleBookList) {
                                              if (saleBook.isbn ==
                                                  _foundBooks[index].isbn) {
                                                matchingSaleBooks.add(saleBook);
                                              }
                                            }
                                            matchingSaleBooks.sort((a, b) => a
                                                .priceRLow
                                                .compareTo(b.priceRLow));

                                            return WishlistSearchRowItem(
                                              book: _foundBooks[index],
                                              lastItem: index ==
                                                  _foundBooks.length - 1,
                                              whishListRef: whishListRef,
                                              availableBooks: matchingSaleBooks,
                                            );
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: _searchTerm != ""
                                    ? Column(
                                        children: [
                                          const Text("Keine Ergebnisse gefunden..."),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: CupertinoButton(
                                                  color: Styles.accent1,
                                                  child: const Text(
                                                      "Buch selbst hinzufügen"),
                                                  onPressed: () => Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              const WishlistAddItem())))),
                                        ],
                                      )
                                    : const Text("Bitte ein Suchwort eingeben"),
                              ));
                  });
            }),
      ],
    );
  }
}
