import 'package:bookmarket/components/listviews/sale_row_item.dart';
import 'package:bookmarket/screens/books/book_sale_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class BookSaleTab extends StatefulWidget {
  const BookSaleTab({Key? key}) : super(key: key);

  @override
  State<BookSaleTab> createState() => _BookSaleTabState();
}

class _BookSaleTabState extends State<BookSaleTab> {
  //Init firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference itemsRef = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .collection('library');

    CollectionReference bookRef = firestore.collection('books');

    List<BookItems> libraryBooks = [];

    return CupertinoPageScaffold(
        backgroundColor: Styles.scaffoldBackground,
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Bibliothek',
            style: Styles.h1,
          ),
          trailing: CupertinoButton(
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const BookSaleSearch())),
            child: const Icon(
              CupertinoIcons.add,
              semanticLabel: "add",
              color: Styles.accent1,
            ),
            //icon inside button
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: itemsRef.snapshots(),
            builder: (BuildContext context, var saleBooksSnapshot) {
              if (saleBooksSnapshot.connectionState ==
                      ConnectionState.waiting ||
                  !saleBooksSnapshot.hasData) {
                return const Center(child: CupertinoActivityIndicator());
              }
              List<QueryDocumentSnapshot<Object?>> salelist =
                  saleBooksSnapshot.data!.docs;

              if (salelist.isEmpty || saleBooksSnapshot.data == null) {
                return const Center(
                    child: Text("Ganz schön leer hier...",
                        style: Styles.standardText));
              }

              return StreamBuilder<QuerySnapshot>(
                  stream: bookRef.snapshots(),
                  builder: (BuildContext context, var bookSnapshot) {
                    if (bookSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        !bookSnapshot.hasData) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    List<BookItems> booklist = bookSnapshot.data!.docs
                        .map((doc) => BookItems.fromJson(
                            (doc.data() as Map<String, dynamic>)))
                        .where((e) => e != null) //<--remove nulls
                        .cast<BookItems>()
                        .toList();

                    libraryBooks = [];
                    // ignore: avoid_function_literals_in_foreach_calls
                    salelist.forEach((element) async {
                      Map<String, dynamic> salelistMap =
                          element.data() as Map<String, dynamic>;

                      for (var book in booklist) {
                        if (book.isbn == salelistMap['isbn']) {
                          BookItems correctBook = BookItems.clone(book);
                          correctBook.uid = salelistMap["uid"];
                          correctBook.priceRLow = salelistMap["priceRLow"];
                          correctBook.priceRHigh = salelistMap["priceRHigh"];
                          libraryBooks.add(correctBook);
                        }
                      }
                    });

                    return SafeArea(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index < libraryBooks.length) {
                                  return SaleRowItem(
                                    book: libraryBooks[index],
                                    lastItem: index == libraryBooks.length - 1,
                                    itemsref: itemsRef,
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
            }));
  }
}
