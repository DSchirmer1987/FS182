import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/models/person.dart';
import 'package:myapp/utils/network.dart';

class PersonDetails extends StatelessWidget {
  Person personObj;

  PersonDetails(this.personObj);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person Details"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(personObj.firstname),
            subtitle: Text('Vorname'),
          ),
          ListTile(
            title: Text(personObj.lastname),
            subtitle: Text('Nachname'),
          ),
          ListTile(
            title: Text(personObj.gender),
            subtitle: Text('Geschlecht'),
          ),
          ListTile(
            title: Text(personObj.email),
            subtitle: Text('E-Mail'),
          ),
          ListTile(
            title: Text(personObj.age.toString()),
            subtitle: Text('Alter'),
          ),
          ListTile(
            title: Text(personObj.birthday),
            subtitle: Text('Geburtsdatum'),
          ),
          ListTile(
            title: personObj.image != null && Network.isAvailable ? Image.network(personObj.image, height: 50, width: 50, alignment: Alignment.centerLeft) : Image.file(new File(personObj.image), height: 50, width: 50, alignment: Alignment.centerLeft,),
            subtitle: Text('Bild'),
          ),
        ],
      ),
    );
  }
}