import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart';

import '../models/expression.dart';
import '../models/sphere.dart';
import '../models/pack.dart';
import '../models/user.dart';

class ScopedUser extends Model {
  String _userAddress = '';
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _bio = '';
  String _profilePicture = '';

  List<Expression> _collectiveExpressions = [];
  List<Sphere> _spheres = Sphere.fetchAll();
  List<Pack> _packs = Pack.fetchAll();

  // get dens
  void getDens() async {
    String url = 'http://127.0.0.1:8888';
    Map<String, String> headers = {"Content-type": "application/json"};
    final body =
        '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "user_dens", "function":"user_dens", "args": {"username_address":"hellos"}}}';

    Response response = await post(url, headers: headers, body: body);
    int statusCode = response.statusCode;
    print(statusCode);
  }
  
  // get pack
  void getPack() async {
    String url = 'http://127.0.0.1:8888';
    Map<String, String> headers = {"Content-type": "application/json"};
    final json =
        '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "user_pack", "function":"user_dens", "args": {"username_address":"hellos"}}}';

    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
  }  

  // create user
  void createUser() async {
    String url = 'http://127.0.0.1:8888';
    Map<String, String> headers = {"Content-type": "application/json"};
    final body =
        '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "core", "function": "create_user", "args": {"user_data": {"username": "sunyata", "first_name": "Eric", "last_name": "Yang", "profile_picture":"yeo", "bio":"hellos"}}}}';

    Response response = await post(url, headers: headers, body: body);
    int statusCode = response.statusCode;
    print(statusCode);

    var hellos = json.decode(response.body);
    print(hellos);
    var hello = response.body;
    print(hello);
    User user = User.fromJson(hellos);
    // print(user);
    print(user.result.address);
    _userAddress = user.result.address;
  }  

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

  List get spheres {
    return _spheres;
  }

  List get packs {
    return _packs;
  }
}
