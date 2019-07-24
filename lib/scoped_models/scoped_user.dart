import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/expression.dart';
import '../models/expressionx.dart';
import '../models/sphere.dart';
import '../models/pack.dart';
import '../models/perspective.dart';
import './models/create_user.dart';
import './models/set_user.dart';

class ScopedUser extends Model {
  String _currentScreen = '';
  String _userAddress = '';
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _bio = '';
  String _profilePicture = '';
  List<Expression> _collectiveExpressions = [];
  List _denExpressions = [];
  List<Sphere> _spheres = Sphere.fetchAll();
  List<Pack> _packs = Pack.fetchAll();
  List<Perspective> _perspectives = Perspective.fetchAll(); 

  // Holochain API address
  String _url = 'http://127.0.0.1:8888';

  // Headers
  Map<String, String> _headers = {"Content-type": "application/json"};

  // Create a unique user 
  void createUser(username, firstName, lastName, profilePicture, bio) async {
    // JSON body
    final body =
      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "user", "function": "create_user", "args": {"user_data": {"username": "' + username + '", "first_name":"' + firstName + '", "last_name":"' + lastName + '", "profile_picture":"' + profilePicture + '", "bio":"' + bio + '"}}}}';

      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "user", "function": "create_user", "args": {"user_data": {"username": "sunyatax", "first_name":"urk", "last_name":"yang", "profile_picture":"profpic", "bio":"love"}}}}';

    // Retrieve response from create_user function
    http.Response response = await http.post(_url, headers: _headers, body: body);

    // Generate status code of response
    int createUserStatus = response.statusCode;

    // Decode and store JSON from reponse.body
    final createUserResponse = json.decode(response.body);

    print(createUserResponse);

    // Generate unique user address and store address, username, first name, last name,
    // profile picture, and bio into state if status code succeeds
    if (createUserStatus == 200) {  
      CreateUser user = CreateUser.fromJson(createUserResponse);
      print(user);
      _userAddress = user.result.ok.privateDen.entry.parent;
      setUsername(user.result.ok.username.usernameEntry.username);
      setFirstName(user.result.ok.profile.profileEntry.firstName);
      setLastName(user.result.ok.profile.profileEntry.lastName);

      setProfilePicture(user.result.ok.profile.profileEntry.profilePicture);      
      setBio(user.result.ok.profile.profileEntry.bio);

      notifyListeners();
    } else {
      print(createUserResponse);
    }
  }  

  void mockSetUser() {
     _username = 'sunyata';
     _firstName = 'Eric';
     _lastName = 'Yang';
     _bio = 'To a mind that is still, the whole universe surrenders';    
  }

  // Set user state attributes (i.e. sign in)
  void setUser(usernameAddress) async {  
    // JSON providing unique username address to retrieve username
    final usernameBody =
      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "get_username_from_address", "args": {"username_address": "' + usernameAddress + '"}}}';
    
    // Retrieve username JSON from Holochain API
    http.Response usernameResponse = await http.post(_url, headers: _headers, body: usernameBody);

    // JSON providing unique username address to retrieve profile
    final profileBody =
      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "get_user_profile_from_address", "args": {"username_address": "' + usernameAddress + '"}}}';    

    // Retrieve profile JSON from Holochain API
    http.Response profileResponse = await http.post(_url, headers: _headers, body: profileBody);

    // Instantiate setUser classes
    SetUserUsername setUserUsername = SetUserUsername.fromJson(json.decode(usernameResponse.body));
    SetUserProfile setUserProfile = SetUserProfile.fromJson(json.decode(profileResponse.body));

    // Update state
    setUsername(setUserUsername.result.ok.username);
    setFirstName(setUserProfile.result.ok.firstName);
    setLastName(setUserProfile.result.ok.lastName);
    setProfilePicture(setUserProfile.result.ok.profilePicture);
    setBio(setUserProfile.result.ok.bio);

    notifyListeners();
  }

  // Retrieve user dens 
  void getDens() async {
    final body =
      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "user_dens", "function":"user_dens", "args": {"username_address":"hellos"}}}';

    http.Response response = await http.post(_url, headers: _headers, body: body);
    int statusCode = response.statusCode;
    print(statusCode);
  }
  
  // Retrieve user pack
  void getPack() async {
    final json =
      '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "user_pack", "function":"user_dens", "args": {"username_address":"hellos"}}}';

    http.Response response = await http.post(_url, headers: _headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
  }  

  // Update username in state
  void setUsername(username) {
    _username = username; 

    notifyListeners();
  }

  // Update first name in state
  void setFirstName(firstName) {
    _firstName = firstName;

    notifyListeners();
  }

  // Update last name in state
  void setLastName(lastName) {
    _lastName = lastName;

    notifyListeners();
  }

  // Update password in state
  void setPassword(password) {
    _password = password;

    notifyListeners();
  }

  // Update bio in state
  void setBio(bio) {
    _bio = bio;

    notifyListeners();
  }

  // Update profile picture in state
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
    return;
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
  List get denExpressions {
    return List.from(_denExpressions);
  }

  List get spheres {
    return _spheres;
  }

  List get packs {
    return _packs;
  }

  List get perspectives {
    return _perspectives;
  }  

  fetchDenExpressions() {
    http.get('https://junto-b48dd.firebaseio.com/expressions.json')
      .then((http.Response response) {
        print(json.decode(response.body));
        final fetchedExpressionList = [];
        final expressionListData = json.decode(response.body);

        expressionListData.forEach((id, expressionData) {
          final expression = Expressionx(
            id: id,
            expressionType: expressionData['expression_type'],
            expression: expressionData['expression'],
            channels: expressionData['tags'],
            comments: expressionData['comments']   
          );

          fetchedExpressionList.add(expression);
        });

        _denExpressions = fetchedExpressionList;
        notifyListeners();
      });    
  }
}


