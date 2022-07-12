import 'package:bookmarket/components/round_avatar.dart';
import 'package:bookmarket/screens/books/book_sale_tab.dart';
import 'package:bookmarket/screens/chat/chat_overview_tab.dart';
import 'package:bookmarket/theme/cupertino_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'screens/books/book_wishlist_tab.dart';
import 'screens/profile_tab.dart';

class BookmarketApp extends StatelessWidget {
  const BookmarketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      //force lightmode for the app (ignore system settings)
      theme: CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(primaryColor: Styles.accent1)),
      home: BookmarketHomePage(),
    );
  }
}

class BookmarketHomePage extends StatelessWidget {
  const BookmarketHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark),
            label: "Wunschliste",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: "Bibliothek",
          ),
          BottomNavigationBarItem(
            icon: RoundAvatar(
                radius: 15,
                imageURL: "",
                userName: ""), //Icon(CupertinoIcons.person),
            label: "Profil",
          ),
        ],
        activeColor: Styles.accent1,
      ),
      tabBuilder: (context, index) {
        late final CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: BookWishlistTab(),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: ChatTab(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: BookSaleTab(),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: ProfileTab(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
