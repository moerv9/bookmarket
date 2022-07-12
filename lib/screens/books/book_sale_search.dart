import 'package:bookmarket/components/listviews/sale_row_search_item.dart';
import 'package:bookmarket/screens/books/book_sale_add_item.dart';
import 'package:bookmarket/service/api_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class BookSaleSearch extends StatelessWidget {
  const BookSaleSearch({Key? key}) : super(key: key);

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
          child: BookSaleSearchForm(),
        ));
  }
}

class BookSaleSearchForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookSaleSearchFormState();
  }
}

class BookSaleSearchFormState extends State<BookSaleSearchForm> {
  //Init Firestore
  FirebaseFirestore fire = FirebaseFirestore.instance;
  late CollectionReference booksRef = fire.collection('books');

  List<BookItems> _allBooks = [];
  List<BookItems> _foundBooks = [];
  String _searchTerm = "";

  APIcall api = APIcall();

  @override
  void initState() {
    _foundBooks = _allBooks;
    super.initState();
  }

  Future<void> _runSearch(String searchTerm) async {
    List<BookItems> results = [];
    if (searchTerm.isNotEmpty) {
      results = _allBooks
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
              List<BookItems> booklist = booksSnapshot.data!.docs
                  .map((doc) =>
                      BookItems.fromJson((doc.data() as Map<String, dynamic>)))
                  .where((e) => e != null) //<--remove nulls
                  .cast<BookItems>()
                  .toList();
              _allBooks = booklist;
              return Expanded(
                  child: _foundBooks.isNotEmpty
                      ? SafeArea(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index < _foundBooks.length) {
                                      return SaleRowSearchItem(
                                        book: _foundBooks[index],
                                        lastItem:
                                            index == _foundBooks.length - 1,
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
                                        padding: const EdgeInsets.all(20.0),
                                        child: CupertinoButton(
                                            color: Styles.accent1,
                                            child: const Text(
                                                "Buch selbst hinzufügen"),
                                            onPressed: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const BookSaleAddItem())))),
                                  ],
                                )
                              : const Text("Bitte ein Suchwort eingeben"),
                        ));
            }),
      ],
    );
  }
}
