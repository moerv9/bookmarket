# Anforderungen, Feedback und Ausblick
Bevor es in die Entwicklung geht haben wir eine Liste an Anforderungen aufgestellt. Die wichtigsten Aspekte dieser Anforderungen haben wir im Prototypen modelliert, den wir darauf getestet haben. Die einzelnen Prototypentests befinden sich [hier](Prototypentest.md).

## MVP
Von unserer Liste an Anforderungen haben wir folgende als Teil unseres MVPs(Minimum Viable Product) festgelegt, der am 31.05 präsentiert werden sollte.
Die App sollte nach erfolgreicher Authentifizierung folgende Seiten beinhalten: Profil, Chat, Wunschliste und Bücherliste.
Der Fokus lag auf den beiden Bücherseiten, da sie den Hauptteil der App darstellen. In der Wunschliste sollen die User ihre Bücher speichern können, die sie haben wollen und es soll angezeigt werden, wenn ein Buch verfügbar ist.
Auf der Bücherliste landen Bücher, die die User selbst anzubieten haben.
Ist ein gesuchtes Buch verfügbar, gelangt man zu dem Chat, um Kontakt mit dem Verkäufer aufzunehmen.
Eine weitere Idee wäre es, eine Filtermöglichkeit in der Chatansicht einzubauen, um zwischen eigenen Büchern und gewünschten Büchern unterscheiden zu können.

Außerdem dachten wir daran, folgende Dinge umzusetzen:
Einen Barcode-Scanner für die Bücher. Eine Literaturliste für Module von Studiengängen und eine Filtermöglichkeit für Universitäten/Hochschulen, Studiengängen, Modulen.
Das wichtigste Feature unserer App sollte allerdings das automatische Matchmaking sein, die Verkäufer und Käufer automatisch zuteilt, sobald es zu einer Übereinstimmung kommt.

Diese letzten Punkte haben wir aber bewusst aus dem MVP herausgelassen und uns erst einmal auf die Hauptfeatures konzentriert. Bei der Präsentation des MVP konnte alles bis auf den Chat präsentiert werden. Die UI war zwar implementiert, aber es gab noch keine Funktionalität. Die Anforderung, einen Kontakt zwischen Verkäufer und Käufer herzustellen, haben wir über einen Button gelöst, der das E-Mail-Programm auf dem Smartphone mit einer vorformulierten E-Mail an den Verkäufer öffnet.

## Feedback
Folgendes Feedback haben wir zu unserem MVP erhalten.
Für Push-Nachrichten, die beim automatischen Matchmaking Sinn ergeben würden, könnten wir das Cloud-Messaging von Firebase verwenden.
Ein Chat darf nicht global einzeln in einer Sammlung in der Datenbank gespeichert werden, da dann das Problem auftritt, wenn ein User den Chat löscht, ist er auch für den anderen User gelöscht. Dies sollten wir verhindern, indem wir den Chat zwar doppelt, aber pro User abspeichern.

Ebenfalls würde es sich anbieten, eine eigene Datenbank für Bücher anzulegen, sodass nur auf die einzelnen Buchobjekte referenziert werden muss und diese nicht mehrfach angelegt werden. Sobald ein Buch beispielsweise auf mehreren Wunschlisten und auch in mehreren Bibliotheken hinzugefügt wurde, hätte man irgendwann oftmals dasselbe Buch in der Datenbank. Dies könnte mit einer eigenen Buchsammlung, wo jedes Buch(oder jede Version eines Buches) nur ein einziges Mal auftaucht und einer Referenz auf diesen Datensatz gelöst werden.

## Anforderungsliste 2
Aus diesem Feedback und mit Berücksichtigung unserer Anforderungsliste vom Anfang haben wir eine neue Liste an Anforderungen formuliert, die bis zur nächsten Präsentation am 23.06 fertiggestellt werden sollte.
Umgesetzt wurde ein funktionierender Chat, der Verkäufer und Käufer über einen Klick verbindet und deren Chat in einer separaten Übersicht wiederzufinden ist.
Die Struktur des Chats in Firebase haben wir nach dem Vorschlag der Feedbackrunde umgesetzt und auch die eigene Sammlung für die Bücher und die Referenzen von den jeweiligen Wunsch-/Bücherlisten wurden implementiert und sind [hier](../docs/Firebase.md) zu sehen.
Bei der Suche nach Büchern haben wir die Google API genutzt und diese so implementiert, dass zuerst in unserer eigenen Datenbank nach verfügbaren Büchern geschaut wird bevor mithilfe der API nachgeschaut wird.
Wenn ein Buch zur Liste hinzugefügt werden soll, soll man noch die Spanne des gewünschten Preises einstellen können. Wir haben uns nämlich überlegt, falls es später zu einem Matching kommen soll, ergibt es Sinn, nicht nur exakte Preise zu matchen, sondern parallel abzugleichen, ob schon ein Buch in der gewünschten Preisspanne vorhanden ist.
All dies wurde auch bis zur Präsentation umgesetzt.
Einzig und allein die Push-Nachrichten haben nicht funktioniert. Alles wurde in Firebase bzw. Cloud Messaging eingestellt, aber die Testnachricht ist nicht auf dem Gerät angekommen und nach mehreren Debug-Versuchen wurde dieses Feature erstmal hinter den anderen zurückgestellt.

## Feedback 2
Aus dem Feedback haben wir mitgenommen, dass wir uns über den Einsatz der API Gedanken machen müssen. Es werden viel zu wenige Suchergebnisse angezeigt. Außerdem muss das Profilbild nach dem Löschen bzw. Ändern in der App auch in Firebase Storage komplett gelöscht bzw. geändert werden.
Es wurde zudem angemerkt, dass die Ladezeit der Bücher in der API-Suche zu lange dauert.

## Finale Anpassung
Das so wenig Suchergebnisse in der API angezeigt wurden lag daran, dass es möglich ist, dass eine IBAN Buchstaben enthält oder ein Buch kein Coverbild oder keine Autoren enthält. Diese Bücher wurden nach unserer Abfrage nicht dargestellt. Dies wurde schlussendlich gefixt. 
Zudem wurde die Ladezeit der Ansicht der Bücher in der Suche durch eine Limitierung signifikant verringert und auch das Abfangen der falschen Werte (Iban) hat die Ladezeit verringert.
Ein Buch kann nun manuell hinzugefügt werden, wenn die API nichts findet. Hier kann man auch ein Buchcover hinzufügen.
Zusätzlich wird das Profilbild jetzt automatisch aus Firebase Storage gelöscht, welches vorher noch nicht funktionierte.

## Ausblick
Als Nächstes würde das automatische Matchmaking und in diesem Zusammenhang ein hoffentlich funktionierendes Push-Nachrichten-System implementiert werden. Damit hätte die App ein eigenes Herausstellungsmerkmal und einen echten Mehrwert.
Danach würden einzelne Aspekte aus den durchgeführten Prototypentests hinzugezogen werden. Einzelne Aspekte aus den Prototypentest, wie ein Bilderupload für Bücher, einen Preisbereich, fehlende Buttons und einheitliche Beschriftungen wurden schon umgesetzt. 
Es könnten auch weitere Aspekte mit einem neuen User-Test evaluiert werden. Mithilfe von Nutzertests sollen dann auch Bugs und fehlende Sinnhaftigkeit ausgemerzt werden.

Schlussendlich könnte es dann zu einem Beta-Test der App mit ausgewählten Usern kommen. Diese unterziehen der App einen Real-Life-Test und danach würde dann die Veröffentlichung im App-Store folgen, aber das ist nochmal ein ganz eigenes Modul wert.
