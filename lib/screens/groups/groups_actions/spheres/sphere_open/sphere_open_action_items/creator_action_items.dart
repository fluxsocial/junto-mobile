import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/avatars/group_avatar_placeholder.dart';
import 'package:junto_beta_mobile/widgets/avatars/group_avatar.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class OwnerActionItems extends StatelessWidget {
  const OwnerActionItems({
    Key key,
    @required this.sphere,
  }) : super(key: key);

  final Group sphere;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Navigator.push(context, EditGroupInfo.route(sphere));
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Edit Sphere',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Provider.of<GroupRepo>(context, listen: false)
                        .deleteGroup(sphere.address);
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Delete Circle',
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditGroupInfo extends StatefulWidget {
  const EditGroupInfo({
    Key key,
    @required this.sphere,
  }) : super(key: key);
  final Group sphere;

  static Route<dynamic> route(Group sphere) {
    return MaterialPageRoute<dynamic>(builder: (
      BuildContext context,
    ) {
      return EditGroupInfo(
        sphere: sphere,
      );
    });
  }

  @override
  _EditGroupInfoState createState() => _EditGroupInfoState();
}

class _EditGroupInfoState extends State<EditGroupInfo> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  File imageFile;
  List<File> groupPicture = <File>[];
  String _photoKey = '';

  GroupDataSphere get _groupData => widget.sphere.groupData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _groupData.name,
    );
    _descriptionController = TextEditingController(
      text: _groupData.description,
    );
    print(imageFile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateGroup() async {
    final GroupRepo _repo = Provider.of<GroupRepo>(context, listen: false);
    final String name = _nameController.text;
    final String desc = _descriptionController.text;

    // check if user uploaded profile pictures
    if (groupPicture != null && groupPicture.isNotEmpty) {
      // instantiate list to store photo keys retrieve from /s3
      try {
        final String key =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto(
          false,
          '.png',
          groupPicture[0],
        );
        setState(() {
          _photoKey = key;
        });
      } catch (error) {
        print(error);
        JuntoLoader.hide();
      }
    }

    final Group updatedGroup = widget.sphere.copyWith(
      groupData: GroupDataSphere(
        name: name,
        description: desc,
        principles: '',
        photo: _photoKey,
        sphereHandle: _groupData.sphereHandle,
      ),
    );
    try {
      JuntoLoader.showLoader(context);
      _repo.updateGroup(updatedGroup);
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          DialogBack(),
        ],
      );
    }
  }

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '3:2',
    ]);
    if (cropped == null) {
      return;
    }
    setState(() {
      imageFile = cropped;
      groupPicture.add(imageFile);
    });
  }

  Widget _displayCurrentProfilePicture() {
    if (_groupData != null &&
        _groupData.photo.isNotEmpty &&
        imageFile == null) {
      return GroupAvatar(
        diameter: 45,
        profilePicture: _groupData.photo,
      );
    } else if (_groupData != null && imageFile != null) {
      return ClipOval(
        child: Container(
          height: 45.0,
          width: 45.0,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else
      return const GroupAvatarPlaceholder(diameter: 45);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
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
                  child: Text('Edit Circle',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                GestureDetector(
                  onTap: () {
                    _updateGroup();
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
      body: SafeArea(
        child: Container(
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
                          hintText: 'Name',
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
                              width: .75),
                        ),
                      ),
                      child: TextField(
                        controller: _descriptionController,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
