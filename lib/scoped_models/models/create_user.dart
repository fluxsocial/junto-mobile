
import 'dart:convert';

// Model for create user function
class CreateUser {
  final String jsonrpc;   
  final result;

  CreateUser({this.jsonrpc, this.result});

  factory CreateUser.fromJson(Map<String, dynamic> parsedJson){
    return CreateUser(
      jsonrpc: parsedJson['jsonrpc'],
      result: CreateUserResult.fromJson(json.decode(parsedJson['result']))
    );
  }
}

class CreateUserResult {
  final ok;

  CreateUserResult({this.ok}); 

  factory CreateUserResult.fromJson(Map<String, dynamic> parsedJson){
    return CreateUserResult(
      ok: CreateUserOk.fromJson(parsedJson['Ok'])
    );
  }

}

class CreateUserOk {
  final privateDen;
  final username;
  final profile;

  CreateUserOk({this.privateDen, this.username, this.profile});

  factory CreateUserOk.fromJson(Map<String, dynamic> parsedJson){
    return CreateUserOk(
      privateDen: CreateUserPrivateDen.fromJson(parsedJson['private_den']),
      username: CreateUserUsername.fromJson(parsedJson['username']),
      profile: CreateUserProfile.fromJson(parsedJson['profile'])

    );
  }  
}
class CreateUserPrivateDen {
  final entry;

  CreateUserPrivateDen({this.entry});

  factory CreateUserPrivateDen.fromJson(Map<String, dynamic> parsedJson){
    return CreateUserPrivateDen(
      entry: CreateUserPrivateDenEntry.fromJson(parsedJson['entry'])
    );
  }  
}

class CreateUserPrivateDenEntry {
  final parent;

  CreateUserPrivateDenEntry({this.parent});

  factory CreateUserPrivateDenEntry.fromJson(Map<String, dynamic> json){
    return CreateUserPrivateDenEntry(
      parent: json['parent']
    );
  }  

}

class CreateUserUsername {
  final usernameEntry;

  CreateUserUsername({this.usernameEntry});

  factory CreateUserUsername.fromJson(Map<String, dynamic> parsedJson){
    return CreateUserUsername(
      usernameEntry: CreateUserUsernameEntry.fromJson(parsedJson['entry'])
    );
  }    
}

class CreateUserUsernameEntry {
  final username;

  CreateUserUsernameEntry({this.username});

  factory CreateUserUsernameEntry.fromJson(Map<String, dynamic> json){
    return CreateUserUsernameEntry(
      username: json['username']
    );
  }    

}

class CreateUserProfile {
  final profileEntry;

  CreateUserProfile({this.profileEntry});

  factory CreateUserProfile.fromJson(Map<String, dynamic> parsedJson){
    return CreateUserProfile(
      profileEntry: CreateUserProfileEntry.fromJson(parsedJson['entry'])
    );
  }    
}

class CreateUserProfileEntry {
  final firstName;
  final lastName;
  final bio;
  final profilePicture;

  CreateUserProfileEntry({this.firstName, this.lastName, this.bio, this.profilePicture});

  factory CreateUserProfileEntry.fromJson(Map<String, dynamic> json){
    return CreateUserProfileEntry(
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],

    );
  }    

}