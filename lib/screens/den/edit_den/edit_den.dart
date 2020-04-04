import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_appbar.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_background_photo.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_header_space.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_profile_picture.dart';
import 'package:junto_beta_mobile/screens/den/edit_den/edit_den_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:provider/provider.dart';

class JuntoEditDen extends StatefulWidget {
  JuntoEditDen({this.currentTheme});

  final String currentTheme;

  @override
  State<StatefulWidget> createState() {
    return JuntoEditDenState();
  }
}

class JuntoEditDenState extends State<JuntoEditDen> {
  String _userAddress;
  UserData _userData;
  UserDataProvider userProvider;

  List<File> profilePictures = <File>[];
  File profilePictureFile;

  String backgroundPhotoKey;
  File backgroundPhotoFile;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserDataProvider>(context);
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
    _userAddress = userProvider.userAddress;
    _userData = userProvider.userProfile;
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

  Future<void> _onPickPressed(String photoType) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      if (photoType == 'profile' && profilePictureFile == null) {
        setState(() {
          profilePictureFile = null;
        });
      } else if (photoType == 'background' && backgroundPhotoFile == null) {
        setState(() {
          backgroundPhotoFile = null;
        });
      }
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      photoType == 'profile' ? '1:1' : '2:1',
    ]);
    if (cropped == null) {
      if (photoType == 'profile' && profilePictureFile == null) {
        setState(() {
          profilePictureFile = null;
        });
      } else if (photoType == 'background' && backgroundPhotoFile == null) {
        setState(() {
          backgroundPhotoFile = null;
        });
      }
      return;
    }

    setState(() {
      if (photoType == 'profile') {
        profilePictureFile = cropped;
        profilePictures = <File>[];
        profilePictures.add(profilePictureFile);
      } else if (photoType == 'background') {
        backgroundPhotoFile = cropped;
      }
    });
  }

  Future<void> _updateUser() async {
    JuntoLoader.showLoader(context);

    Map<String, dynamic> _newProfileBody;

    _newProfileBody = <String, dynamic>{
      'name': _nameController.value.text,
      'location': _locationController.value.text == ''
          ? null
          : <String>[_locationController.value.text],
      'bio': _bioController.value.text == '' ? null : _bioController.value.text,
      'website': _websiteController.value.text == ''
          ? null
          : <String>[_websiteController.value.text],
      'gender': _genderController.value.text == ''
          ? null
          : <String>[_genderController.value.text],
    };

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
          } catch (e, s) {
            logger.logException(e, s);
            print(e.message);
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

      _newProfileBody['profile_picture'] = _profilePictureKeys;
    }

    // check if user uploaded background photo
    if (backgroundPhotoFile != null) {
      // instantiate list to store photo keys retrieve from /s3
      try {
        final String key =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto(
          true,
          '.png',
          backgroundPhotoFile,
        );
        setState(() {
          backgroundPhotoKey = key;
        });
      } catch (e, s) {
        logger.logException(e, s);
        JuntoLoader.hide();
      }
      _newProfileBody['background_photo'] = backgroundPhotoKey;
    }
    // update user
    try {
      final UserProfile updatedUser =
          await Provider.of<UserRepo>(context, listen: false).updateUser(
        _newProfileBody,
        _userAddress,
      );
      final _user = userProvider.userProfile.copyWith(user: updatedUser);
      userProvider.updateUser(_user);
      JuntoLoader.hide();
      Navigator.of(context).pushReplacement(
        FadeRoute<void>(
          child: JuntoDen(),
        ),
      );
    } catch (e, s) {
      logger.logException(e, s);
      JuntoLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: EditDenAppbar(updateUser: _updateUser),
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          EditDenBackgroundPhoto(
                            profile: _userData,
                            backgroundPhotoFile: backgroundPhotoFile,
                            onPickPressed: _onPickPressed,
                            currentTheme: widget.currentTheme,
                          ),
                          EditDenHeaderSpace(),
                          EditDenTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                          ),
                          EditDenTextField(
                            controller: _locationController,
                            hintText: 'Location',
                          ),
                          EditDenTextField(
                            controller: _genderController,
                            hintText: 'Gender Pronouns',
                          ),
                          EditDenTextField(
                            controller: _websiteController,
                            hintText: 'Website',
                          ),
                          EditDenTextField(
                            controller: _bioController,
                            hintText: 'Short/Long Bio',
                          ),
                        ],
                      ),
                      EditDenProfilePicture(
                        userData: _userData,
                        profilePictureFile: profilePictureFile,
                        onPickPressed: _onPickPressed,
                      )
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
