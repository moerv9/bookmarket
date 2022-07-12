import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../screens/books/book_wishlist_search_extraData.dart';
import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class WishlistSearchRowItem extends StatelessWidget {
  const WishlistSearchRowItem({
    required this.book,
    required this.lastItem,
    required this.whishListRef,
    required this.availableBooks,
    Key? key,
  }) : super(key: key);

  final BookItems book;
  final bool lastItem;
  final CollectionReference whishListRef;
  final List<BookItems> availableBooks;

  @override
  Widget build(BuildContext context) {
    final row = GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BookWishlistSearchExtraData(
                        book: book,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: (availableBooks.isNotEmpty)
                  ? Styles.availableBackground
                  : null),
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
              right: 8,
            ),
            child: Stack(
              children: [
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        //Book Cover
                        book.coverImgURL,
                        fit: BoxFit.cover,
                        height: 76,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book.title,
                              style: Styles.h2,
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 2.5)),
                            Text(
                              'ISBN: ${book.isbn}',
                              style: Styles.subtitleText,
                            ),
                            Text(
                              'Autor*in: ${book.author}',
                              style: Styles.subtitleText,
                            ),
                            Text(
                              book.year.toString(),
                              style: Styles.subtitleText,
                            ),
                            if (availableBooks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Verfügbar ab ",
                                      style: Styles.subtitleText,
                                    ),
                                    Text(
                                      "${availableBooks[0].priceRLow.toString()}€",
                                      style: Styles.availableText,
                                    )
                                  ],
                                ),
                              ),
                            const Padding(padding: EdgeInsets.only(top: 8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(left: 100, right: 16),
          child: Container(
            height: 1,
            color: Styles.divider,
          ),
        ),
      ],
    );
  }
}
