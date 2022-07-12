/* 
IMPORTANT COMMANDS

#check 
flutter doctor

# open xcode:
open ios/Runner.xcworkspace

# after changing branch, when imports fail:
flutter pub get

# after flutter upgrade:
flutter clean
flutter pub get
flutter pub upgrade

# fix ios build errors:
cd ios
rm Podfile.lock
rm Podfile
pod init
pod install
*/

/*
Error: CocoaPods's specs repository is too out-of-date to satisfy dependencies.

Go to /ios folder inside your Project.
Delete Podfile.lock

cd ios
pod install --repo-update
cd ..
flutter clean 
flutter run

Stateful Widget ändern ihren State (Shortcut: stful)
Stateless Widgets bleiben so wie sie sind (Shortcut: stless)
*/

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login_tab.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder:(context,_) => const LoginApp(),
        ),
    ],
  ));
}


