
import 'dart:convert';

class User {
  String jsonrpc;
  var result;

  User({this.jsonrpc, this.result});

  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
      jsonrpc: parsedJson['jsonrpc'],
      result: Result.fromJson(json.decode(parsedJson['result']))
    );
  }
}

class Result {
  var ok;

  Result({this.ok}); 

  factory Result.fromJson(Map<String, dynamic> parsedJson){
    return Result(
      ok: Ok.fromJson(parsedJson['Ok'])
    );
  }

}

class Ok {
  var privateDen;
  Ok({this.privateDen});

  factory Ok.fromJson(Map<String, dynamic> parsedJson){
    return Ok(
      privateDen: PrivateDen.fromJson(parsedJson['private_den'])
    );
  }  
}
class PrivateDen {
  var entry;

  PrivateDen({this.entry});

  factory PrivateDen.fromJson(Map<String, dynamic> parsedJson){
    return PrivateDen(
      entry: Entry.fromJson(parsedJson['entry'])
    );
  }  
}

class Entry {
  var parent;

  Entry({this.parent});

  factory Entry.fromJson(Map<String, dynamic> json){
    return Entry(
      parent: json['parent']
    );
  }  

}
