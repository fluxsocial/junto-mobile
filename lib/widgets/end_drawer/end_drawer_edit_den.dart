import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:provider/provider.dart';

class JuntoEditDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoEditDenState();
  }
}

class JuntoEditDenState extends State<JuntoEditDen> {
  String _userAddress;
  UserData _userData;

  String _name;
  String _bio;
  List<String> _location;
  List<String> _website;

  TextEditingController _nameController;
  TextEditingController _bioController;
  TextEditingController _locationController;
  TextEditingController _genderController;
  TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();

    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userData = UserData.fromMap(decodedUserData);
    });
    setEditInfo();
  }

  void setEditInfo() {
    print('setting info');
    setState(() {
      _name = _userData.user.name;
      _bio = _userData.user.bio;
      _location = _userData.user.location;
      _website = _userData.user.website;
    });

    _nameController = TextEditingController(text: _userData.user.name);
    _bioController = TextEditingController(text: _userData.user.bio);
    _locationController = TextEditingController(
        text: _userData.user.location[0] == null
            ? ''
            : _userData.user.location[0]);
    _genderController = TextEditingController(
        text: _userData.user.gender[0] == null ? '' : _userData.user.gender[0]);
    _websiteController = TextEditingController(
        text:
            _userData.user.website[0] == null ? '' : _userData.user.website[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Container(
                  child: Text('Edit Profile',
                      style: Theme.of(context).textTheme.subhead),
                ),
                GestureDetector(
                  onTap: () async {
                    final Map<String, dynamic> newProfile = {
                      'name': _nameController.value.text,
                      'location': _locationController.value.text == ''
                          ? <String>[]
                          : <String>[_locationController.value.text],
                      'bio': _bioController.value.text,
                      'website': _websiteController.value.text == ''
                          ? <String>[]
                          : <String>[_websiteController.value.text],
                      'gender': _genderController.value.text == ''
                          ? <String>[]
                          : <String>[_genderController.value.text],
                    };
                    try {
                      await Provider.of<UserRepo>(context, listen: false)
                          .updateUser(newProfile, _userAddress);
                    } catch (error) {
                      print(error);
                      print(error.message);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    width: 42,
                    height: 42,
                    child:
                        Text('Save', style: Theme.of(context).textTheme.body2),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Row(children: <Widget>[
                      ClipOval(
                        child: Image.asset(
                          'assets/images/junto-mobile__mockprofpic--one.png',
                          height: 45.0,
                          width: 45.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Edit profile pictures',
                          style: Theme.of(context).textTheme.body2)
                    ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .75),
                          ),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Full Name'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'NAME',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .75),
                          ),
                        ),
                        child: TextField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Short/Long Bio'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'BIO',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .75),
                          ),
                        ),
                        child: TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Location'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'LOCATION',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .75),
                          ),
                        ),
                        child: TextField(
                          controller: _genderController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Gender'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'GENDER',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .75),
                          ),
                        ),
                        child: TextField(
                          controller: _websiteController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Website'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'WEBSITE',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
