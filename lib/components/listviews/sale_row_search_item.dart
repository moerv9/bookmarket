import 'package:bookmarket/models/books_db.dart';
import 'package:bookmarket/screens/books/book_sale_editData.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:flutter/cupertino.dart';

class SaleRowSearchItem extends StatelessWidget {
  const SaleRowSearchItem({
    required this.book,
    required this.lastItem,
    Key? key,
  }) : super(key: key);

  final BookItems book;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    final row = GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BookSaleEditItem(
                        book: book,
                      )));
        },
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
                          // Text(
                          //   '${book.version}. Version',
                          //   style: Styles.subtitleText,
                          // ),
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
            ],
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
