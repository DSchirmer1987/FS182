import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/person.dart';
import 'package:myapp/utils/network.dart';
import 'package:myapp/widgets/redressedText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonDetails extends StatelessWidget {
  Person personObj;

  PersonDetails(this.personObj);

  @override
  Widget build(BuildContext context) {
    print(Platform.localeName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Person Details"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(personObj.firstname, style: TextStyle(fontFamily: 'Redressed'),),
            subtitle: Text(AppLocalizations.of(context).firstname),
          ),
          ListTile(
            title: RedressedText(personObj.lastname),
            subtitle: Text(AppLocalizations.of(context).lastname),
          ),
          ListTile(
            title: Text(personObj.gender),
            subtitle: Text(AppLocalizations.of(context).gender),
          ),
          ListTile(
            title: Text(personObj.email, style: GoogleFonts.eastSeaDokdo(),),
            subtitle: Text(AppLocalizations.of(context).email),
          ),
          ListTile(
            title: Text(personObj.age.toString()),
            subtitle: Text(AppLocalizations.of(context).age),
          ),
          ListTile(
            title: Text(personObj.birthday),
            subtitle: Text(AppLocalizations.of(context).birthday),
          ),
          ListTile(
            title:  Network.isAvailable && personObj.image.contains('http') ? 
                    Image.network(personObj.image, height: 50, width: 50, alignment: Alignment.centerLeft) :
                    personObj.image.isNotEmpty && !personObj.image.contains('http')?
                    Image.file(new File(personObj.image), height: 50, width: 50, alignment: Alignment.centerLeft,) : 
                    Image.asset('lib/images/default-avatar.png', height: 50, width: 50, alignment: Alignment.centerLeft,),
            subtitle: Text(AppLocalizations.of(context).picture),
          ),
        ],
      ),
    );
  }
}