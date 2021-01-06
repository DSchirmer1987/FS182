import 'dart:convert';
import 'package:http/http.dart' as http;

class Person {
  String firstname;
  String lastname;
  String gender;
  String birthday;
  String email;
  int age;
  String image;

  Person(this.firstname, this.lastname, {this.gender, this.birthday, this.email, this.age, this.image});

  String toJson(){
    Map<String, dynamic> map = Map<String, dynamic>();
    map['firstname'] = this.firstname;
    map['lastname'] = this.lastname;
    map['gender'] = this.gender;
    map['birthday'] = this.birthday;
    map['email'] = this.email;
    map['age'] = this.age;
    map['image'] = this.image;

    return jsonEncode(map);
  }

  static Person fromJson(String json){
    Map<String, dynamic> map = jsonDecode(json);
    return Person(map['firstname'], map['lastname'], gender: map['gender'], birthday: map['birthday'], email: map['email'] ,age: map['age'], image: map['image']);
  }

  // ignore: missing_return
  static Future<String> fromHttp() async{
    var json = await http.get("https://randomname.de/?format=json&count=1&images=1");
    if(json != null){
      if(json.statusCode == 200){
        return Future.value(json.body);
      }
    }
  }
}