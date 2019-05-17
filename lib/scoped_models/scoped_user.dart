
// import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/expression.dart';
import '../models/sphere.dart';
import '../models/pack.dart';

class ScopedUser extends Model {
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _bio = '';
  String _profilePicture = '';

  List<Expression> _collectiveExpressions = [];
  List<Sphere> _spheres = Sphere.fetchAll();
  List<Pack> _packs = Pack.fetchAll();

  // set username for member
  void setUsername(username) {
    _username = username; 
    
    notifyListeners();
  }
  
  // set first for member
  void setFirstName(firstName) {
    _firstName = firstName; 
    
    notifyListeners();
  }

  // set last name for member
  void setLastName(lastName) {
    _lastName = lastName; 
    
    notifyListeners();
  }    

  // set password for member (temporary function)
  void setPassword(password) {
    _password = password; 
    
    notifyListeners();
  }
  
  // set bio for member
  void setBio(bio) {
    _bio = bio; 
    
    notifyListeners();
  }

  // set profile picture for member
  void setProfilePicture(profilePicture) {
    _profilePicture = profilePicture; 
    
    notifyListeners();
  }      

  // Set collective expressions for member
  void setCollectiveExpressions() {
    _collectiveExpressions = Expression.fetchAll();
  }

  // Set following list for member
  setFollowingExpressions() {
    return ;
  }
  
  // Set perspectives for member 
  setPerspectives() {
    return;
  }

  // set spheres for member
  setSpheres() {
    return;
  }

  // set packs for member
  setPacks() {
    return;
  }

  // getters
  get username {
    return _username;
  }

  get firstName {
    return _firstName;
  }  

  get lastName {
    return _lastName;
  }    

  get password {
    return _password;
  }

  get bio {
    return _bio;
  }     

  get profilePicture {
    return _profilePicture;
  }  

  List get collectiveExpressions {
    return List.from(_collectiveExpressions);
  }

  List get spheres {
    return _spheres;
  }  

  List get packs {
    return _packs;
  }    
}