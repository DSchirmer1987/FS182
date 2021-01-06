import 'package:flutter/material.dart';
import 'package:myapp/newPerson.dart';
import 'package:myapp/personDetails.dart';
import 'package:myapp/personenListe.dart';
import 'package:myapp/secondpage.dart';

import 'utils/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Network.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      // routes: {
      //   '/': (context) => PersonenListe(),
      //   'zweiteSeite': (context) => SecondPage(),
      //   'newPerson': (context) => NewPerson(),
      //   'personDetails': (context) => PersonDetails(),
      // },
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
