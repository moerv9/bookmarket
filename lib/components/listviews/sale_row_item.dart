import 'package:bookmarket/screens/books/book_sale_editData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/books_db.dart';
import '../../theme/cupertino_style.dart';

class SaleRowItem extends StatelessWidget {
  const SaleRowItem({
    required this.book,
    required this.lastItem,
    required this.itemsref,
    Key? key,
  }) : super(key: key);

  final CollectionReference itemsref;
  final BookItems book;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    final row = Slidable(
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
                        const Padding(padding: EdgeInsets.only(bottom: 2.5)),
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
                        const Padding(padding: EdgeInsets.only(top: 8)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 0,
              child: Row(
                children: [
                  const Text(
                    'Dein Preis: ',
                    style: Styles.subtitleText,
                  ),
                  Text(
                    "${book.priceRLow.toString()}€",
                    style: Styles.availableText,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => BookSaleEditItem(book: book)));
            },
            backgroundColor: Styles.accent2,
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
      ),
    );

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
