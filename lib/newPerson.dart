import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/person.dart';

class NewPerson extends StatelessWidget {
  Person person;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> textEditingController = {
    'firstname' : TextEditingController(),
    'lastname': TextEditingController(),
    'gender': TextEditingController(),
    'birthday': TextEditingController(),
    'email' : TextEditingController(),
    'age': TextEditingController(),
    'image': TextEditingController()
  };
  File _image;
  final picker = ImagePicker();

  NewPerson({this.person}){
    if (this.person != null){
      textEditingController['firstname'].text = this.person.firstname;
      textEditingController['lastname'].text = this.person.lastname;
      textEditingController['gender'].text = this.person.gender;
      textEditingController['age'].text = this.person.age.toString();
      textEditingController['birthday'].text = this.person.birthday;
      textEditingController['email'].text = this.person.email;
      textEditingController['image'].text = this.person.image;
    }
  }

  bool checkCharactersOnly(String value){
    String pattern = r'(^[a-zA-Z ]+$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void pickImage() async{
    final image = await picker.getImage(source: ImageSource.gallery);
    if(image != null){
      _image = File(image.path);
      textEditingController['image'].text = image.path;
    }
  }

  void takePhoto() async{
    final image = await picker.getImage(source: ImageSource.camera);
    if(image != null){
      _image = File(image.path);
      textEditingController['image'].text = _image.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this.person == null ? Text("Person Einfügen") : Text('Person editieren'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: textEditingController['firstname'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Vorname'
                ),
                validator: (String value) {
                  return checkCharactersOnly(value) ? null : 'Bitte nur Buchstaben eingeben!';                
                },
              ),
              TextFormField(
                controller: textEditingController['lastname'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nachname'
                ),
                validator: (String value) {
                  return checkCharactersOnly(value) ? null : 'Bitte nur Buchstaben eingeben!';                
                },
              ),
              TextFormField(
                controller: textEditingController['email'],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'EMail'
                ),
                validator: (String value) {
                  return value.contains('@') ? null : 'E-Mail muss ein @ enthalten';                
                },
              ),
              TextFormField(
                controller: textEditingController['birthday'],
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Geburtstag'
                ),
                validator: (String value) {
                  return null;                
                },
              ),
              TextFormField(
                controller: textEditingController['age'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Alter'
                ),
                validator: (String value) {
                  String pattern = r'(^[0-9]+$)';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value) ? null : 'Bitte nur Zahlen eingeben';              
                },
              ),
              TextFormField(
                controller: textEditingController['gender'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Geschlecht'
                ),
                validator: (String value) {
                  if(value.length == 1 && (value.contains('f') || value.contains('m'))){
                    return null;
                  } else {
                    return 'Nur ein Buchstabe und nur m/f verwenden!';
                  }  
                },
              ),
              TextFormField(
                controller: textEditingController['image'],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Bild'
                ),
                validator: (String value) {
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Speichern'),
                onPressed: () async{
                  SharedPreferences preferences = await _prefs;
                  List<String> personen = preferences.getStringList('SavedPersonen');
                  if(this.person == null){
                    if(formKey.currentState.validate()){
                      textEditingController.forEach((key, value) {print(value.text);});
                      Person person = new Person(textEditingController['firstname'].text,
                                                textEditingController['lastname'].text,
                                                email: textEditingController['email'].text,
                                                age: int.parse(textEditingController['age'].text), 
                                                birthday: textEditingController['birthday'].text,
                                                gender: textEditingController['gender'].text,
                                                image: textEditingController['image'].text
                                                );
                      personen.add(person.toJson());
                      preferences.setStringList('SavedPersonen', personen);
                    }
                  } else {
                    this.person.firstname = textEditingController['firstname'].text;
                    this.person.lastname = textEditingController['lastname'].text;
                    this.person.gender = textEditingController['gender'].text;
                    this.person.email = textEditingController['email'].text;
                    this.person.birthday = textEditingController['birthday'].text;
                    this.person.image = textEditingController['image'].text;
                    this.person.age = int.parse(textEditingController['age'].text);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        )
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.photo),
            onTap: () {
              this.takePhoto();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.photo_album),
            onTap: () {
              this.pickImage();
            },
          )
        ],
      ),
    );
  }
}