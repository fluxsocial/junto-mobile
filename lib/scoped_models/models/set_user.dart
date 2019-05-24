
import 'dart:convert';

class SetUserUsername {
  String jsonrpc;
  var result;

  SetUserUsername({this.jsonrpc, this.result});

  factory SetUserUsername.fromJson(Map<String, dynamic> parsedJson){
    return SetUserUsername(
      jsonrpc: parsedJson['jsonrpc'],
      result: SetUserUsernameResult.fromJson(json.decode(parsedJson['result']))
    );
  }
}

class SetUserUsernameResult {
  var ok;

  SetUserUsernameResult({this.ok}); 

  factory SetUserUsernameResult.fromJson(Map<String, dynamic> parsedJson){
    return SetUserUsernameResult(
      ok: SetUserUsernameOk.fromJson(parsedJson['Ok'])
    );
  }

}

class SetUserUsernameOk {
  var username;

  SetUserUsernameOk({this.username});

  factory SetUserUsernameOk.fromJson(Map<String, dynamic> parsedJson){
    return SetUserUsernameOk(
      username: parsedJson['username']
    );
  }  

}





class SetUserProfile {
  String jsonrpc;
  var result;

  SetUserProfile({this.jsonrpc, this.result});

  factory SetUserProfile.fromJson(Map<String, dynamic> parsedJson){
    return SetUserProfile(
      jsonrpc: parsedJson['jsonrpc'],
      result: SetUserProfileResult.fromJson(json.decode(parsedJson['result']))
    );
  }
}

class SetUserProfileResult {
  var ok;

  SetUserProfileResult({this.ok}); 

  factory SetUserProfileResult.fromJson(Map<String, dynamic> parsedJson){
    return SetUserProfileResult(
      ok: SetUserProfileOk.fromJson(parsedJson['Ok'])
    );
  }

}

class SetUserProfileOk {
  var firstName;
  var lastName;
  var bio;
  var profilePicture;

  SetUserProfileOk({this.firstName, this.lastName, this.bio, this.profilePicture});

  factory SetUserProfileOk.fromJson(Map<String, dynamic> parsedJson){
    return SetUserProfileOk(
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      bio: parsedJson['bio'],
      profilePicture: parsedJson['profile_picture'],
    );
  }  

}