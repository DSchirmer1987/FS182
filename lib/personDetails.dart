import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/person.dart';
import 'package:myapp/utils/network.dart';
import 'package:myapp/widgets/redressedText.dart';

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
            title: Text(personObj.firstname, style: TextStyle(fontFamily: 'Redressed'),),
            subtitle: Text('Vorname'),
          ),
          ListTile(
            title: RedressedText(personObj.lastname),
            subtitle: Text('Nachname'),
          ),
          ListTile(
            title: Text(personObj.gender),
            subtitle: Text('Geschlecht'),
          ),
          ListTile(
            title: Text(personObj.email, style: GoogleFonts.eastSeaDokdo(),),
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
            title:  Network.isAvailable && personObj.image.contains('http') ? 
                    Image.network(personObj.image, height: 50, width: 50, alignment: Alignment.centerLeft) :
                    personObj.image.isNotEmpty && !personObj.image.contains('http')?
                    Image.file(new File(personObj.image), height: 50, width: 50, alignment: Alignment.centerLeft,) : 
                    Image.asset('lib/images/default-avatar.png', height: 50, width: 50, alignment: Alignment.centerLeft,),
            subtitle: Text('Bild'),
          ),
        ],
      ),
    );
  }
}