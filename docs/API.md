# Google Api für die Büchersuche
Die [Google Books API](https://developers.google.com/books) ermöglicht es Nutzern kostenlos Informationen über Bücher aus dem Google Books Katalog zu erhalten. Zusätzlich können Daten und die persönliche Mediathek von Google Books Nutzern ausgegeben und sogar editiert werden.


## Nutzung
Für die grundlegende Nutzung der Google Books API ist lediglich ein API-Key nötig, welcher über die [Google Cloud Konsole](https://console.cloud.google.com/apis/credentials?) konfiguriert und generiert werden kann.
Dieser API-Key ermöglicht seinem Besitzer das Abfragen von Daten aus dem Google Books Katalog. Für den den Zugriff auf von persönliche Daten ist ein OAuth2-Flow nötig.
Um an die Daten zu gelangen wird eine einfache HTTP-Get-Request mit dem Such-Query, dem API-Key sowie verschiedenen Parameter-Querys an die API geschickt.  Die Anzahl der maximal ausgegebenen Bücher lässt sich durch ein Query anpassen, wodurch sich zum Beispiel die Größe von Datensätzen beeinflussen lässt.

Eine HTTP-Request in Bookmarket setzt sich aus drei Teilen zusammen. 

- Suchinhalt `_requestParam = "Harry Potter"`
- Maximale Suchergebnisse `maxApiResults  = 20`
- API-Key `_apiKey = AIzaSyAqHlkfwaekfjpFKd8MarDDWDjpwMnMivWQM`
- Zusätzlich würde durch das Query `printType = books` festgelegt, dass die API nur Bücher als Ergebnis zurück gibt, die in gedruckter Form erhältlich sind.

Daraus ergibt sich beispielsweise folgende GET-Request an die API:

```
https://www.googleapis.com/books/v1/volumes?q=harry potter&maxResults=20&printType=books&key=AIzaSyAqHlkfwaekfjpFKd8MarDDWDjpwMnMivWQM 
```



## Dateninhalt & Aufbau
Die Response stellt einen JSON-String mit allen den Suchparametern entsprechenden Büchern dar.
Auf der obersten Ebene enthält der JSON-String, neben seiner Art (`"kind": "books#volumes"`) und der Menge seines Gesamtinhalts (`"totalItems": 1083`) ein Array (`items = []`), in welchem die Bücher als einzelne Objekte (`items`) vorliegen.
Ein Buch besitzt eine `id`, einen `etag` und einen `selfLink`, welcher den JSON-String des Buchs aufruft. In jedem Buch ist ein Array `volumeInfo` enthalten, welches die Daten zum Buch, teilweise verschachtelt in weiteren Arrays hält.
So befinden sich in `volumeInfo` alle wichtigen Parameter, wie Titel (`title`), Herausgeber (`publisher`), der Klappentext (`description`) oder das Veröffentlichungsdatum (`publishedDate`).
In weiteren Arrays, wie z.B. `industryIdentifiers` befinden sich die verschiedenen ISBN-Nummern des Buchs oder Coverbilder aus dem Array `imageLinks` in unterschiedlichen Größen.
Neben den Daten zum Buch selbst, liefert die API auch Ergebnisse wie durchschnittliche Bewertungen, Verkaufsinformationen. Auf diese wird in der App jedoch nicht zugegriffen.

Bsp.:
```
{
    "kind": "books#volumes",
    "totalItems": 1205,
    "items": [
        {
            "kind": "books#volume",
            "id": "XtekEncdTZcC",
            "etag": "VwkVtQ0N7ZY",
            "selfLink": "https://www.googleapis.com/books/v1/volumes/XtekEncdTZcC",
            "volumeInfo": {
                "title": "Harry Potter und der Stein der Weisen",
                "authors": [
                    "J.K. Rowling"
                ],
                "publisher": "Pottermore Publishing",
                "publishedDate": "2015-12-08",
                "description": "Eigentlich hatte Harry geglaubt, er sei ein ganz normaler Junge. Zumindest bis zu seinem elften Geburtstag. Da erfährt er, dass er sich an der Schule für Hexerei und Zauberei einfinden soll. Und warum? Weil Harry ein Zauberer ist. Und so wird für Harry das erste Jahr in der Schule das spannendste, aufregendste und lustigste in seinem Leben. Er stürzt von einem Abenteuer in die nächste ungeheuerliche Geschichte, muss gegen Bestien, Mitschüler und Fabelwesen kämpfen. Da ist es gut, dass er schon Freunde gefunden hat, die ihm im Kampf gegen die dunklen Mächte zur Seite stehen.",
                "industryIdentifiers": [
                    {
                        "type": "ISBN_13",
                        "identifier": "9781781100769"
                    },
                    {
                        "type": "ISBN_10",
                        "identifier": "1781100764"
                    }
                ],
                "readingModes": {
                    "text": true,
                    "image": true
                },
                "pageCount": 335,
                "printType": "BOOK",
                "categories": [
                    "Fiction"
                ],
                "averageRating": 4,
                "ratingsCount": 79,
                "maturityRating": "NOT_MATURE",
                "allowAnonLogging": true,
                "contentVersion": "1.10.12.0.preview.3",
                "panelizationSummary": {
                    "containsEpubBubbles": false,
                    "containsImageBubbles": false
                },
                "imageLinks": {
                    "smallThumbnail": "http://books.google.com/books/content?id=XtekEncdTZcC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                    "thumbnail": "http://books.google.com/books/content?id=XtekEncdTZcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
                },
                "language": "de",
                "previewLink": "http://books.google.de/books?id=XtekEncdTZcC&printsec=frontcover&dq=harry+potter&hl=&as_pt=BOOKS&cd=1&source=gbs_api",
                "infoLink": "https://play.google.com/store/books/details?id=XtekEncdTZcC&source=gbs_api",
                "canonicalVolumeLink": "https://play.google.com/store/books/details?id=XtekEncdTZcC"
            },
            "saleInfo": {
                "country": "DE",
                "saleability": "FOR_SALE",
                "isEbook": true,
                "listPrice": {
                    "amount": 2.99,
                    "currencyCode": "EUR"
                },
                "retailPrice": {
                    "amount": 2.99,
                    "currencyCode": "EUR"
                },
                "buyLink": "https://play.google.com/store/books/details?id=XtekEncdTZcC&rdid=book-XtekEncdTZcC&rdot=1&source=gbs_api",
                "offers": [
                    {
                        "finskyOfferType": 1,
                        "listPrice": {
                            "amountInMicros": 2990000,
                            "currencyCode": "EUR"
                        },
                        "retailPrice": {
                            "amountInMicros": 2990000,
                            "currencyCode": "EUR"
                        },
                        "giftable": true
                    }
                ]
            },
            "accessInfo": {
                "country": "DE",
                "viewability": "PARTIAL",
                "embeddable": true,
                "publicDomain": false,
                "textToSpeechPermission": "ALLOWED",
                "epub": {
                    "isAvailable": true,
                    "acsTokenLink": "http://books.google.de/books/download/Harry_Potter_und_der_Stein_der_Weisen-sample-epub.acsm?id=XtekEncdTZcC&format=epub&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
                },
                "pdf": {
                    "isAvailable": true,
                    "acsTokenLink": "http://books.google.de/books/download/Harry_Potter_und_der_Stein_der_Weisen-sample-pdf.acsm?id=XtekEncdTZcC&format=pdf&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
                },
                "webReaderLink": "http://play.google.com/books/reader?id=XtekEncdTZcC&hl=&as_pt=BOOKS&printsec=frontcover&source=gbs_api",
                "accessViewStatus": "SAMPLE",
                "quoteSharingAllowed": false
            },
            "searchInfo": {
                "textSnippet": "Eigentlich hatte Harry geglaubt, er sei ein ganz normaler Junge."
            }
        }
    ]
}
```
Diese Daten können dann durch die Verarbeitung in eigenen Klassen (siehe [Klasse ApiBook](#klasse-apibook)) genutzt werden, um die Bücher in der App darzustellen.

## Klasse ApiBook

Die Klasse [ApiBook](../lib/models/api_book.dart) wurde mithilfe des Tools [Quicktype](https://app.quicktype.io/#) aus einem Beispiel-JSON generiert und in Zuge der Entwicklungen an die Bedürfnisse der App angepasst.
Besondere Herausforderungen waren hierbei die Null-Checks unterschiedlicher Werte, sowie das Casten in verwendbare Datentypen. 
So musste beispielsweise kurzfristig der Datentyp der ISBN in der Klasse [BookItems](../lib/models/books_db.dart) vom Typ `double` zum Typ `String` geändert werden, da ISBN-Variationen existieren, in denen auch Buchstaben Verwendung finden.