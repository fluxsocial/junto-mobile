import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JuntoEditDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoEditDenState();
  }
}

class JuntoEditDenState extends State<JuntoEditDen> {
  String _userAddress;
  UserData _userData;

  List<File> profilePictures = <File>[];

  File imageFile;
//ignore:unused_field
  String _name;
  //ignore:unused_field
  String _bio;
  //ignore:unused_field
  List<String> _location;
  //ignore:unused_field
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
    _locationController =
        TextEditingController(text: _userData.user.location[0] ?? '');
    _genderController =
        TextEditingController(text: _userData.user.gender[0] ?? '');
    _websiteController =
        TextEditingController(text: _userData.user.website[0] ?? '');
  }

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() => imageFile = null);
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '1:1',
    ]);
    if (cropped == null) {
      setState(() => imageFile = null);
      return;
    }
    setState(() {
      imageFile = cropped;
      profilePictures = <File>[];
      profilePictures.add(imageFile);
    });
  }

  Future<void> _updateUser() async {
    JuntoLoader.showLoader(context);

    Map<String, dynamic> _newProfileBody;
    // check if user uploaded profile pictures
    if (profilePictures.isNotEmpty) {
      // instantiate list to store photo keys retrieve from /s3
      final List<String> _photoKeys = <String>[];
      for (final dynamic image in profilePictures) {
        if (image != null) {
          try {
            final String key =
                await Provider.of<ExpressionRepo>(context, listen: false)
                    .createPhoto(
              false,
              '.png',
              image,
            );
            _photoKeys.add(key);
          } catch (error) {
            print(error);
            JuntoLoader.hide();
          }
        }
      }

      final List<Map<String, dynamic>> _profilePictureKeys =
          <Map<String, dynamic>>[
        <String, dynamic>{'index': 0, 'key': _photoKeys[0]},
        if (_photoKeys.length == 2)
          <String, dynamic>{'index': 1, 'key': _photoKeys[1]},
      ];

      _newProfileBody = _newProfileBody = <String, dynamic>{
        'profile_picture': _profilePictureKeys,
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
    } else {
      _newProfileBody = <String, dynamic>{
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
    }

    // update user
    try {
      await Provider.of<UserRepo>(context, listen: false)
          .updateUser(_newProfileBody, _userAddress);
      JuntoLoader.hide();
      Navigator.of(context).push(
        PageRouteBuilder<dynamic>(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return JuntoDen();
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ),
        ),
      );
    } catch (error) {
      print(error);
      JuntoLoader.hide();
    }
  }

  _displayCurrentProfilePicture() {
    if (_userData != null &&
        _userData.user.profilePicture.isNotEmpty &&
        imageFile == null) {
      return ClipOval(
        child: CachedNetworkImage(
            imageUrl: _userData.user.profilePicture[0],
            height: 45,
            width: 45,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String _) {
              return Container(
                alignment: Alignment.center,
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.3, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  CustomIcons.spheres,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 17,
                ),
              );
            }),
      );
    } else if (_userData != null &&
        _userData.user.profilePicture.isNotEmpty &&
        imageFile != null) {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          height: 45.0,
          width: 45.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const <double>[0.3, 0.9],
              colors: <Color>[
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary
              ],
            ),
          ),
          child: Image.file(imageFile),
        ),
      );
    } else
      return Container(
        alignment: Alignment.center,
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.3, 0.9],
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary
            ],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset('assets/images/junto-mobile__logo--white.png',
            height: 15),
      );
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
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                GestureDetector(
                  onTap: () {
                    _updateUser();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    width: 42,
                    height: 42,
                    child: Text('Save',
                        style: Theme.of(context).textTheme.bodyText1),
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
                  GestureDetector(
                    onTap: () {
                      _onPickPressed();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: .75),
                        ),
                      ),
                      child: Row(children: <Widget>[
                        _displayCurrentProfilePicture(),
                        const SizedBox(width: 10),
                        Text('Edit profile picture',
                            style: Theme.of(context).textTheme.bodyText1)
                      ]),
                    ),
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
                            border: InputBorder.none,
                            hintText: 'Full Name',
                          ),
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
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
                          controller: _bioController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Short/Long Bio',
                          ),
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
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
                          controller: _locationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Location',
                          ),
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
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
                          controller: _genderController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Gender'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
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
                          controller: _websiteController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Website'),
                          maxLines: null,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
