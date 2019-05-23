
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
  var username;
  var profile;

  Ok({this.privateDen, this.username, this.profile});

  factory Ok.fromJson(Map<String, dynamic> parsedJson){
    return Ok(
      privateDen: PrivateDen.fromJson(parsedJson['private_den']),
      username: Username.fromJson(parsedJson['username']),
      profile: Profile.fromJson(parsedJson['profile'])

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

class Username {
  var usernameEntry;

  Username({this.usernameEntry});

  factory Username.fromJson(Map<String, dynamic> parsedJson){
    return Username(
      usernameEntry: UsernameEntry.fromJson(parsedJson['entry'])
    );
  }    
}

class UsernameEntry {
  var username;

  UsernameEntry({this.username});

  factory UsernameEntry.fromJson(Map<String, dynamic> json){
    return UsernameEntry(
      username: json['username']
    );
  }    

}

class Profile {
  var profileEntry;

  Profile({this.profileEntry});

  factory Profile.fromJson(Map<String, dynamic> parsedJson){
    return Profile(
      profileEntry: ProfileEntry.fromJson(parsedJson['entry'])
    );
  }    
}

class ProfileEntry {
  var firstName;
  var lastName;
  var bio;
  var profilePicture;

  ProfileEntry({this.firstName, this.lastName, this.bio, this.profilePicture});

  factory ProfileEntry.fromJson(Map<String, dynamic> json){
    return ProfileEntry(
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],

    );
  }    

}