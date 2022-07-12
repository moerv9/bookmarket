import 'package:bookmarket/models/api_book.dart';
import 'package:bookmarket/models/books_db.dart';
import 'package:http/http.dart' as http;

class APIcall {
  final _apiKey = "AIzaSyAqHljGLuOoyuFKd8MarDURawQMnMivWQM";
  final int maxApiResults = 20; // max amount of Items called from API

  String buildURL(String requestParam) {
    String requestURL = 'https://www.googleapis.com/books/v1/volumes?q=' +
        requestParam +
        '&maxResults=' +
        maxApiResults.toString() +
        '&printType=books&key=' +
        _apiKey;
    return requestURL;
  }

  List<BookItems> buildApiBook(String json) {
    ApiBook apiBooks = apiBookFromJson(json);
    List<BookItems> apiBookItems = [];

    //if api has no results -> ApiBook is null
    if (apiBooks.items != null) {
      for (var i = 0; i < apiBooks.items!.length; i++) {
        apiBookItems.add(BookItems(
            "",
            apiBooks.getISBN(i),
            apiBooks.getTitle(i),
            apiBooks.getCoverImage(i),
            apiBooks.getAuthors(i),
            apiBooks.getPublisher(i),
            "1",// Auflage
            int.parse(apiBooks.getPublishDate(i)),
            0,
            0));
      }
    }

    return apiBookItems;
  }

  Future<List<BookItems>> fetchBooks(String requestParam) async {
    final response = await http.get(Uri.parse(buildURL(requestParam)));

    if (response.statusCode == 200) {
      return buildApiBook(response.body);
    } else {
      throw Exception('unable to load book');
    }
  }
}
