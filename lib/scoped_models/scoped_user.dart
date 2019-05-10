
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

  List<Expression> _collectiveExpressions = Expression.fetchAll();
  List<Sphere> _spheres = Sphere.fetchAll();
  List<Pack> _packs = Pack.fetchAll();

  
  setUsername(x) {
    _username = x; 
    
    print(_username);
    notifyListeners();
  }
  
  setFirstName(x) {
    _firstName = x; 
    
    print(firstName);
    notifyListeners();
  }

  setLastName(x) {
    _lastName = x; 
    
    print(_lastName);
    notifyListeners();
  }    

  setPassword(x) {
    _password = x; 
    
    notifyListeners();
  }
  
  setBio(x) {
    _bio = x; 
    
    notifyListeners();
  }

  setProfilePicture(x) {
    _profilePicture = x; 
    
    notifyListeners();
  }      

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