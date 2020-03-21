import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController _nameController;
  TextEditingController _bioController;
  TextEditingController _locationController;
  TextEditingController _genderController;
  TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _genderController = TextEditingController();
    _websiteController = TextEditingController();
    getUserInformation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _genderController.dispose();
    _websiteController.dispose();
    super.dispose();
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
    _nameController.text = _userData.user.name;
    _bioController.text = _userData.user.bio;
    _locationController.text =
        _userData.user.location.isNotEmpty ? _userData.user.location[0] : '';
    _genderController.text =
        _userData.user.gender.isNotEmpty ? _userData.user.gender[0] : '';
    _websiteController.text =
        _userData.user.website.isNotEmpty ? _userData.user.website[0] : '';
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
    if (profilePictures != null && profilePictures.isNotEmpty) {
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
        'bio': _bioController?.value?.text,
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
      await Provider.of<UserRepo>(context, listen: false).updateUser(
        _newProfileBody,
        _userAddress,
      );
      JuntoLoader.hide();
      Navigator.of(context).pushReplacement(FadeRoute<void>(child: JuntoDen()));
    } catch (error) {
      JuntoLoader.hide();
    }
  }

  Widget _displayCurrentProfilePicture() {
    if (_userData != null && imageFile == null) {
      return MemberAvatar(
        diameter: 60,
        profilePicture: _userData.user.profilePicture,
      );
    } else {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          height: 60.0,
          width: 60.0,
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
    }
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
                  child: Text('Edit Den',
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
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/junto-mobile__themes--rainbow.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                            width: .75,
                          ),
                        ),
                      ),
                      child: Row(children: <Widget>[
                        _displayCurrentProfilePicture(),
                        const SizedBox(width: 10),
                        Text('Change profile picture',
                            style: Theme.of(context).textTheme.bodyText1)
                      ]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: _genderController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Gender Pronouns'),
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: _websiteController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Website',
                      ),
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
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
            )
          ],
        ),
      ),
    );
  }
}
