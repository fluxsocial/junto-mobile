
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
  var address;

  Result({this.address});

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      address: json['Ok']
    );
  }

}

