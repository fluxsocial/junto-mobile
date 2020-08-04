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
import 'package:junto_beta_mobile/screens/den/edit_den/update_photo_options.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
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
    userProvider = Provider.of<UserDataProvider>(context, listen: false);
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

  void _updatePhotoOptions(String photoType) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (BuildContext context) => UpdatePhotoOptions(
        updatePhoto: _onPickPressed,
        photoType: photoType,
      ),
    );
  }

  Future<void> _onPickPressed(String photoType, String source) async {
    File image;
    final imagePicker = ImagePicker();
    //TODO: replace strings with enum
    if (source == 'Gallery') {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      image = File(pickedImage.path);
    } else if (source == 'Camera') {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.camera);
      image = File(pickedImage.path);
    }
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

    final updatedName = _nameController.value.text.trim();
    final updatedLocation = _locationController.value.text.trim();
    final updatedBio = _bioController.value.text.trim();
    final updatedWebsite = _websiteController.value.text.trim();
    final updatedGender = _genderController.value.text.trim();

    if (updatedName.isEmpty) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Your name cannot be empty.',
        ),
      );
      return;
    }

    _newProfileBody = <String, dynamic>{
      'name': updatedName,
      'location': <String>[updatedLocation],
      'bio': updatedBio,
      'website': <String>[updatedWebsite],
      'gender': <String>[updatedGender],
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
                            onPressed: _updatePhotoOptions,
                          ),
                          EditDenHeaderSpace(),
                          EditDenTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            maxLength: 38,
                          ),
                          EditDenTextField(
                            controller: _locationController,
                            hintText: 'Location',
                            maxLength: 38,
                          ),
                          EditDenTextField(
                            controller: _genderController,
                            hintText: 'Gender Pronouns',
                            maxLength: 22,
                          ),
                          EditDenTextField(
                            controller: _websiteController,
                            hintText: 'Website',
                            maxLength: 100,
                          ),
                          EditDenTextField(
                            controller: _bioController,
                            hintText: 'Short/Long Bio',
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 1000,
                          ),
                        ],
                      ),
                      EditDenProfilePicture(
                        userData: _userData,
                        profilePictureFile: profilePictureFile,
                        onPressed: _updatePhotoOptions,
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
