import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/models/person.dart';
import 'package:myapp/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonenListe extends StatefulWidget {
  @override
  _PersonenListeState createState() => _PersonenListeState();
}

class _PersonenListeState extends State<PersonenListe> {
  List<Person> personen = List<Person>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPersonenliste();
    Network.registerSubscription(updateUI);
  }

  void updateUI(){
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text("Netzwerkstatus"),
      //       content: Text("Network changed to " + Network.isAvailable.toString()),
      //       actions: [
      //         RaisedButton(
      //           child: Text("Ok"),
      //           onPressed: () => Navigator.of(context).pop(),
      //         ),
      //       ],
      //     );
      //   },
      // );
      // Scaffold.of(context).showSnackBar(snackBar);
      scaffoldkey.currentState.showSnackBar(snackBar);
    setState(() {
      
    });
  }

  void getPersonenliste() async{
    SharedPreferences preferences = await _prefs;
    setState(() {
      if(preferences.getStringList('SavedPersonen') != null){
        for(String json in preferences.getStringList('SavedPersonen')){
          personen.add(Person.fromJson(json));
        }
      }
    });
  }

  void getPerson() async{
    List<String> stringListe = List<String>();
    SharedPreferences preferences = await _prefs;
    await Person.fromHttp().then((value){
      var person = jsonDecode(value);
      print(person[0]);
      setState(() {
        for(var p in person){
          Person personObj = new Person(p['firstname'], p['lastname'], gender:p['gender'], birthday: p['birthday'], email: p['email'], age:p['age'], image: p['image']);
          personen.add(personObj);
        }
        for(Person pObj in personen){
          stringListe.add(pObj.toJson());
        }
        preferences.setStringList('SavedPersonen', stringListe);
      });
    });
  }

  void clearPersonenListe() async{
    SharedPreferences preferences = await _prefs;
    setState(() {
      personen = List<Person>();
    });
    preferences.setStringList('SavedPersonen', null);
  }

  final snackBar = SnackBar(
    content: Text('Network failed'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('PersonenListe'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('My Drawer'),
            ),
            ListTile(
              title: Text("Liste leeren"),
              onTap: () => clearPersonenListe(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: personen.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(personen.elementAt(index).firstname + ' ' + personen.elementAt(index).lastname),
                  leading: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,),
                    onPressed: () async{
                      SharedPreferences preferences = await _prefs;
                      List<String> stringListe = List<String>();
                      print("Gelöscht");
                      setState(() {
                        personen.removeAt(index);
                        for(Person pObj in personen){
                          stringListe.add(pObj.toJson());
                        }
                        preferences.setStringList('SavedPersonen', stringListe);
                      });                      
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async{
                      SharedPreferences preferences = await _prefs;
                      List<String> stringListe = List<String>();
                      Navigator.pushNamed(context, 'newPerson', arguments: personen.elementAt(index)).then((value){
                        setState(() {
                          for(Person pObj in personen){
                            stringListe.add(pObj.toJson());
                          }
                            preferences.setStringList('SavedPersonen', stringListe);
                        });
                      });
                    }
                    ,
                  ),
                  onTap: () => Navigator.pushNamed(context, 'personDetails', arguments: personen.elementAt(index)),
                );
              },
            ),
          ),
          SizedBox(height: 100.0,)
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Hinzufügen',
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            labelBackgroundColor: Colors.pink[700],
            onTap: Network.isAvailable ? () => getPerson() : () => showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: Text("Netzwerkstatus"),
                                                                    content: Text("No Network available"),
                                                                    actions: [
                                                                      RaisedButton(
                                                                        child: Text("Ok"),
                                                                        onPressed: () => Navigator.of(context).pop(),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
          ),
          SpeedDialChild(
            child: Icon(Icons.sanitizer),
            label: 'Surprise',
            onTap: () => clearPersonenListe()
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Person hinzufügen',
            onTap: () async{
              SharedPreferences preferences = await _prefs; 
              Navigator.pushNamed(context, 'newPerson').then((value) {
                setState((){
                  personen = List<Person>();
                  for(String json in preferences.getStringList('SavedPersonen')){
                    personen.add(Person.fromJson(json));
                  }
                });
              });
            }
          )
        ],
      ),
    );
  }
}