import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/newPerson.dart';
import 'package:myapp/personDetails.dart';
import 'package:myapp/personenListe.dart';
import 'package:myapp/secondpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/services/pushNotificationsservice.dart';
import 'utils/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Network.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final pushNotificationService = PushNotificationService(_firebaseMessaging);
    // pushNotificationService.initialise();
    return MaterialApp(
      localizationsDelegates:
      AppLocalizations.localizationsDelegates, 
      // [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      supportedLocales: 
      AppLocalizations.supportedLocales,
      // [
      //   const Locale('en', ''),
      //   const Locale('de', ''),
      //   const Locale('es', '')
      // ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ignore: missing_return
      onGenerateRoute: (settings) {
        switch (settings.name){
          case '/': {
            return MaterialPageRoute(builder: (BuildContext context) => PersonenListe());
          }
          case 'zweiteSeite': {
            return MaterialPageRoute(builder: (BuildContext context) => SecondPage());
          }
          case 'newPerson': {
            return MaterialPageRoute(builder: (BuildContext context) => NewPerson(person: settings.arguments));
          }
          case 'personDetails': {
            return MaterialPageRoute(builder: (BuildContext context) => PersonDetails(settings.arguments));
          }
        }
      } ,
    );
  }
}
