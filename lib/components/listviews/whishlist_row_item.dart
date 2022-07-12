import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../screens/books/book_wishlist_search_extraData.dart';
import '../../screens/chat/user_chat.dart';
import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class WishlistRowItem extends StatelessWidget {
  const WishlistRowItem({
    required this.book,
    required this.lastItem,
    required this.itemsref,
    required this.availableBooks,
    Key? key,
  }) : super(key: key);

  final CollectionReference itemsref;
  final BookItems book;
  final bool lastItem;
  final List<BookItems> availableBooks;

  @override
  Widget build(BuildContext context) {
    final row = GestureDetector(
        onTap: () {
          if (availableBooks.isNotEmpty) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => UserChat(
                          otherUid: availableBooks[0].uid,
                        ),
                    settings: RouteSettings(arguments: availableBooks[0])));
          }
        },
        child: Slidable(
            child: Container(
                decoration: BoxDecoration(
                    color: (availableBooks.isNotEmpty)
                        ? (book.priceRHigh <= availableBooks[0].priceRLow)
                            ? Styles.availableButToExpensiveBackground
                            : Styles.availableBackground
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Wunschpreis: ',
                                        style: Styles.subtitleText,
                                      ),
                                      Text(
                                        '${book.priceRLow}€ - ${book.priceRHigh}€',
                                        style: Styles.subtitleText,
                                      ),
                                    ],
                                  ),
                                  if (availableBooks.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BookWishlistSearchExtraData(
                                  book: book,
                                )));
                  },
                  backgroundColor: Styles.edit,
                  foregroundColor: Styles.scaffoldBackground,
                  icon: CupertinoIcons.pencil_circle,
                  label: 'Ändern',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) {
                    BookItems.deleteItem(itemsref, book.isbn);
                  },
                  backgroundColor: Styles.delete,
                  foregroundColor: Styles.scaffoldBackground,
                  icon: CupertinoIcons.xmark_circle,
                  label: 'Löschen',
                ),
              ],
            )));

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

  void delete() {
    logger.d("Gelöscht");
  }
}
