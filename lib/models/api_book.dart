// To parse this JSON data, do
//
//     final apiBook = apiBookFromJson(jsonString);
//
//--------------------------------------------------

import 'dart:convert';

ApiBook apiBookFromJson(String str) => ApiBook.fromJson(json.decode(str));

String apiBookToJson(ApiBook data) => json.encode(data.toJson());

String defaultNoCover =
    "https://firebasestorage.googleapis.com/v0/b/bookmarket-999999.appspot.com/o/cover%2FnoCover.jpg?alt=media&token=0a81d966-7705-4a82-b59f-b361ec3d86ca";

class ApiBook {
  ApiBook({
    required this.kind,
    required this.totalItems,
    this.items,
  });

  String kind;
  int totalItems;
  List<Item>? items;

  factory ApiBook.fromJson(Map<String, dynamic> json) => ApiBook(
        kind: json["kind"],
        totalItems: json["totalItems"],
        items: json["totalItems"] > 0 //return null if api has no items
            ? List<Item>.from(json["items"]
                .map((item) => Item.fromJson(item))
                .where((item) =>
                    item.volumeInfo!.industryIdentifiers != null &&
                    item.volumeInfo!.industryIdentifiers![0].type != null))
            : null, //remove items, where the isbn is not available/other type
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "totalItems": totalItems,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };

  getISBN(int index) {
    if (items![index].volumeInfo!.industryIdentifiers!.isNotEmpty) {
      return items![index].volumeInfo!.industryIdentifiers![0].identifier;
    } else {
      return 0;
    }
  }

  String getTitle(int index) {
    if (items![index].volumeInfo!.title!.isNotEmpty) {
      return items![index].volumeInfo!.title!.toString();
    } else {
      return "null";
    }
  }

  String getCoverImage(int index) {
    if (items![index].volumeInfo!.imageLinks != null) {
      return items![index].volumeInfo!.imageLinks!.thumbnail.toString();
    } else {
      return defaultNoCover;
    }
  }

  String getAuthors(int index) {
    String _authorString = "";
    for (int i = 0; i < items![index].volumeInfo!.authors.length; i++) {
      _authorString += items![index].volumeInfo!.authors[i].toString() + ", ";
    }
    return _authorString.substring(0, _authorString.length - 2);
  }

  String getPublisher(int index) {
    if (items![index].volumeInfo!.publisher != null) {
      return items![index].volumeInfo!.publisher.toString();
    } else {
      return "Publisher";
    }
  }

  String getPublishDate(int index) {
    if (items![index].volumeInfo!.publishedDate != null) {
      String _dateString = items![index].volumeInfo!.publishedDate.toString();
      return _dateString.substring(
          0, (_dateString.length + 4) - _dateString.length);
    } else {
      return "null";
    }
  }
}

class Item {
  Item({
    this.kind,
    this.id,
    this.etag,
    this.selfLink,
    this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
    this.searchInfo,
  });

  Kind? kind;
  String? id;
  String? etag;
  String? selfLink;
  VolumeInfo? volumeInfo;
  SaleInfo? saleInfo;
  AccessInfo? accessInfo;
  SearchInfo? searchInfo;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: kindValues.map[json["kind"]],
        id: json["id"],
        etag: json["etag"],
        selfLink: json["selfLink"],
        volumeInfo: VolumeInfo.fromJson(json["volumeInfo"]),
        saleInfo: SaleInfo.fromJson(json["saleInfo"]),
        accessInfo: AccessInfo.fromJson(json["accessInfo"]),
        searchInfo: json["searchInfo"] == null
            ? null
            : SearchInfo.fromJson(json["searchInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kindValues.reverse[kind],
        "id": id,
        "etag": etag,
        "selfLink": selfLink,
        "volumeInfo": volumeInfo!.toJson(),
        "saleInfo": saleInfo!.toJson(),
        "accessInfo": accessInfo!.toJson(),
        "searchInfo": searchInfo == null ? null : searchInfo!.toJson(),
      };
}

class AccessInfo {
  AccessInfo({
    this.country,
    this.viewability,
    this.embeddable,
    this.publicDomain,
    this.textToSpeechPermission,
    this.epub,
    this.pdf,
    this.webReaderLink,
    this.accessViewStatus,
    this.quoteSharingAllowed,
  });

  Country? country;
  Viewability? viewability;
  bool? embeddable;
  bool? publicDomain;
  TextToSpeechPermission? textToSpeechPermission;
  Epub? epub;
  Epub? pdf;
  String? webReaderLink;
  AccessViewStatus? accessViewStatus;
  bool? quoteSharingAllowed;

  factory AccessInfo.fromJson(Map<String, dynamic> json) => AccessInfo(
        country: countryValues.map[json["country"]],
        viewability: viewabilityValues.map[json["viewability"]],
        embeddable: json["embeddable"],
        publicDomain: json["publicDomain"],
        textToSpeechPermission:
            textToSpeechPermissionValues.map[json["textToSpeechPermission"]],
        epub: Epub.fromJson(json["epub"]),
        pdf: Epub.fromJson(json["pdf"]),
        webReaderLink: json["webReaderLink"],
        accessViewStatus: accessViewStatusValues.map[json["accessViewStatus"]],
        quoteSharingAllowed: json["quoteSharingAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "country": countryValues.reverse[country],
        "viewability": viewabilityValues.reverse[viewability],
        "embeddable": embeddable,
        "publicDomain": publicDomain,
        "textToSpeechPermission":
            textToSpeechPermissionValues.reverse[textToSpeechPermission],
        "epub": epub!.toJson(),
        "pdf": pdf!.toJson(),
        "webReaderLink": webReaderLink,
        "accessViewStatus": accessViewStatusValues.reverse[accessViewStatus],
        "quoteSharingAllowed": quoteSharingAllowed,
      };
}

enum AccessViewStatus { NONE, SAMPLE }

final accessViewStatusValues = EnumValues(
    {"NONE": AccessViewStatus.NONE, "SAMPLE": AccessViewStatus.SAMPLE});

enum Country { DE }

final countryValues = EnumValues({"DE": Country.DE});

class Epub {
  Epub({
    this.isAvailable,
  });

  bool? isAvailable;

  factory Epub.fromJson(Map<String, dynamic> json) => Epub(
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "isAvailable": isAvailable,
      };
}

enum TextToSpeechPermission { ALLOWED }

final textToSpeechPermissionValues =
    EnumValues({"ALLOWED": TextToSpeechPermission.ALLOWED});

enum Viewability { NO_PAGES, PARTIAL }

final viewabilityValues = EnumValues(
    {"NO_PAGES": Viewability.NO_PAGES, "PARTIAL": Viewability.PARTIAL});

enum Kind { BOOKS_VOLUME }

final kindValues = EnumValues({"books#volume": Kind.BOOKS_VOLUME});

class SaleInfo {
  SaleInfo({
    this.country,
    this.saleability,
    this.isEbook,
  });

  Country? country;
  Saleability? saleability;
  bool? isEbook;

  factory SaleInfo.fromJson(Map<String, dynamic> json) => SaleInfo(
        country: countryValues.map[json["country"]],
        saleability: saleabilityValues.map[json["saleability"]],
        isEbook: json["isEbook"],
      );

  Map<String, dynamic> toJson() => {
        "country": countryValues.reverse[country],
        "saleability": saleabilityValues.reverse[saleability],
        "isEbook": isEbook,
      };
}

enum Saleability { NOT_FOR_SALE }

final saleabilityValues =
    EnumValues({"NOT_FOR_SALE": Saleability.NOT_FOR_SALE});

class SearchInfo {
  SearchInfo({
    this.textSnippet,
  });

  String? textSnippet;

  factory SearchInfo.fromJson(Map<String, dynamic> json) => SearchInfo(
        textSnippet: json["textSnippet"],
      );

  Map<String, dynamic> toJson() => {
        "textSnippet": textSnippet,
      };
}

class VolumeInfo {
  VolumeInfo({
    this.title,
    required this.authors,
    this.publishedDate,
    this.industryIdentifiers,
    this.readingModes,
    this.pageCount,
    this.printType,
    this.maturityRating,
    this.allowAnonLogging,
    this.contentVersion,
    this.panelizationSummary,
    this.imageLinks,
    this.language,
    this.previewLink,
    this.infoLink,
    this.canonicalVolumeLink,
    this.subtitle,
    this.publisher,
    this.description,
    this.categories,
  });

  String? title;
  List<String> authors = [""];
  String? publishedDate;
  List<IndustryIdentifier>? industryIdentifiers;
  ReadingModes? readingModes;
  int? pageCount;
  PrintType? printType;
  MaturityRating? maturityRating;
  bool? allowAnonLogging;
  ContentVersion? contentVersion;
  PanelizationSummary? panelizationSummary;
  ImageLinks? imageLinks;
  Language? language;
  String? previewLink;
  String? infoLink;
  String? canonicalVolumeLink;
  String? subtitle;
  String? publisher;
  String? description;
  List<String>? categories;

  factory VolumeInfo.fromJson(Map<String, dynamic> json) => VolumeInfo(
        title: json["title"],
        authors: json["authors"] != null
            ? List<String>.from(json["authors"].map((x) => x))
            : [''],
        publishedDate: json["publishedDate"],
        industryIdentifiers: json["industryIdentifiers"] != null
            ? List<IndustryIdentifier>.from(json["industryIdentifiers"]
                .map((x) => IndustryIdentifier.fromJson(x)))
            : null,
        readingModes: ReadingModes.fromJson(json["readingModes"]),
        pageCount: json["pageCount"] ?? null,
        printType: printTypeValues.map[json["printType"]],
        maturityRating: maturityRatingValues.map[json["maturityRating"]],
        allowAnonLogging: json["allowAnonLogging"],
        contentVersion: contentVersionValues.map[json["contentVersion"]],
        panelizationSummary: json["panelizationSummary"] == null
            ? null
            : PanelizationSummary.fromJson(json["panelizationSummary"]),
        imageLinks: json["imageLinks"] == null
            ? null
            : ImageLinks.fromJson(json["imageLinks"]),
        language: languageValues.map[json["language"]],
        previewLink: json["previewLink"],
        infoLink: json["infoLink"],
        canonicalVolumeLink: json["canonicalVolumeLink"],
        subtitle: json["subtitle"],
        publisher: json["publisher"],
        description: json["description"],
        categories: json["categories"] == null
            ? null
            : List<String>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "authors": List<dynamic>.from(authors.map((x) => x)),
        "publishedDate": publishedDate,
        "industryIdentifiers":
            List<dynamic>.from(industryIdentifiers!.map((x) => x.toJson())),
        "readingModes": readingModes!.toJson(),
        "pageCount": pageCount == null ? null : pageCount,
        "printType": printTypeValues.reverse[printType],
        "maturityRating": maturityRatingValues.reverse[maturityRating],
        "allowAnonLogging": allowAnonLogging,
        "contentVersion": contentVersionValues.reverse[contentVersion],
        "panelizationSummary":
            panelizationSummary == null ? null : panelizationSummary!.toJson(),
        "imageLinks": imageLinks == null ? null : imageLinks!.toJson(),
        "language": languageValues.reverse[language],
        "previewLink": previewLink,
        "infoLink": infoLink,
        "canonicalVolumeLink": canonicalVolumeLink,
        "subtitle": subtitle == null ? null : subtitle,
        "publisher": publisher == null ? null : publisher,
        "description": description == null ? null : description,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x)),
      };
}

enum ContentVersion { PREVIEW_100, THE_0020_PREVIEW_1 }

final contentVersionValues = EnumValues({
  "preview-1.0.0": ContentVersion.PREVIEW_100,
  "0.0.2.0.preview.1": ContentVersion.THE_0020_PREVIEW_1
});

class ImageLinks {
  ImageLinks({
    this.smallThumbnail,
    this.thumbnail,
  });

  String? smallThumbnail;
  String? thumbnail;

  factory ImageLinks.fromJson(Map<String, dynamic> json) => ImageLinks(
        smallThumbnail: json["smallThumbnail"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "smallThumbnail": smallThumbnail,
        "thumbnail": thumbnail,
      };
}

class IndustryIdentifier {
  IndustryIdentifier({
    this.type,
    this.identifier,
  });

  Type? type;
  String? identifier;

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) =>
      IndustryIdentifier(
        type: typeValues.map[json["type"]],
        identifier: json["identifier"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "identifier": identifier,
      };
}

enum Type { ISBN_10, ISBN_13 }

final typeValues =
    EnumValues({"ISBN_10": Type.ISBN_10, "ISBN_13": Type.ISBN_13});

enum Language { DE }

final languageValues = EnumValues({"de": Language.DE});

enum MaturityRating { NOT_MATURE }

final maturityRatingValues =
    EnumValues({"NOT_MATURE": MaturityRating.NOT_MATURE});

class PanelizationSummary {
  PanelizationSummary({
    this.containsEpubBubbles,
    this.containsImageBubbles,
  });

  bool? containsEpubBubbles;
  bool? containsImageBubbles;

  factory PanelizationSummary.fromJson(Map<String, dynamic> json) =>
      PanelizationSummary(
        containsEpubBubbles: json["containsEpubBubbles"],
        containsImageBubbles: json["containsImageBubbles"],
      );

  Map<String, dynamic> toJson() => {
        "containsEpubBubbles": containsEpubBubbles,
        "containsImageBubbles": containsImageBubbles,
      };
}

enum PrintType { BOOK }

final printTypeValues = EnumValues({"BOOK": PrintType.BOOK});

class ReadingModes {
  ReadingModes({
    this.text,
    this.image,
  });

  bool? text;
  bool? image;

  factory ReadingModes.fromJson(Map<String, dynamic> json) => ReadingModes(
        text: json["text"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "image": image,
      };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
