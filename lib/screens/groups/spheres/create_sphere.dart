import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSphere extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateSphereState();
  }
}

class CreateSphereState extends State<CreateSphere> {
  File imageFile;
  String imageKey = '';
  int _currentIndex = 0;
  String sphereName;
  String sphereHandle;
  String sphereDescription;

  PageController createSphereController;
  TextEditingController sphereNameController;
  TextEditingController sphereHandleController;
  TextEditingController sphereDescriptionController;
  String _currentPrivacy = 'Public';

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() => imageFile = null);
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '3:2',
    ]);
    if (cropped == null) {
      setState(() => imageFile = null);
      return;
    }
    setState(() => imageFile = cropped);
  }

  Future<void> _createSphere() async {
    // check if photo
    if (imageFile != null) {
      final String _photoKey = await Provider.of<ExpressionRepo>(context, listen: false)
          .createPhoto('.png', imageFile);
      print(_photoKey);
      setState(() {
        imageKey = _photoKey;
      });
    }

    // then
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userAddress = prefs.get('user_id');

    final CentralizedSphere sphere = CentralizedSphere(
      name: sphereName,
      description: sphereDescription,
      facilitators: <String>[userAddress],
      photo: imageKey,
      members: <String>[],
      principles: '',
      sphereHandle: sphereHandle,
      privacy: _currentPrivacy,
    );
    print(sphere.photo);

    try {
      JuntoLoader.showLoader(context);
      await Provider.of<GroupRepo>(context).createSphere(sphere);
      JuntoLoader.hide();
      Navigator.pop(context);
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    createSphereController = PageController();
    sphereNameController = TextEditingController();
    sphereHandleController = TextEditingController();
    sphereDescriptionController = TextEditingController();

    super.initState();
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
                _currentIndex == 0
                    ? GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          color: Colors.transparent,
                          width: 48,
                          alignment: Alignment.centerLeft,
                          child: Icon(CustomIcons.cancel,
                              size: 24,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          createSphereController.previousPage(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          color: Colors.transparent,
                          width: 60,
                          alignment: Alignment.centerLeft,
                          child: Icon(CustomIcons.back,
                              size: 17,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                Text('Create Sphere',
                    style: Theme.of(context).textTheme.subhead),
                _currentIndex == 2
                    ? GestureDetector(
                        onTap: () {
                          // create sphere
                          _createSphere();
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(right: 10),
                          width: 60,
                          alignment: Alignment.centerRight,
                          child: Text('create',
                              style: Theme.of(context).textTheme.caption),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_currentIndex == 0) {
                            setState(() {
                              sphereName = sphereNameController.value.text;
                              sphereHandle = sphereHandleController.value.text;
                              sphereDescription =
                                  sphereDescriptionController.value.text;
                            });
                          }
                          createSphereController.nextPage(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(right: 10),
                          width: 48,
                          alignment: Alignment.centerRight,
                          child: Text('next',
                              style: Theme.of(context).textTheme.caption),
                        ),
                      )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(color: Theme.of(context).dividerColor),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: createSphereController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() {
                    print(index);
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                  _createSphereOne(),
                  _createSphereTwo(),
                  _createSphereThree()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createSphereOne() {
    return ListView(children: <Widget>[
      imageFile == null
          ? GestureDetector(
              onTap: () {
                _onPickPressed();
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.width / 3) * 2,
                  color: Theme.of(context).dividerColor,
                  child: Icon(CustomIcons.camera,
                      size: 38, color: Theme.of(context).primaryColorLight)),
            )
          : Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
              GestureDetector(
                onTap: () {
                  _openChangePhotoModal();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor, width: .75),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Change photo',
                          style: Theme.of(context).textTheme.caption),
                      Icon(Icons.keyboard_arrow_right,
                          color: Theme.of(context).primaryColorLight)
                    ],
                  ),
                ),
              ),
            ]),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
            controller: sphereNameController,
            buildCounter: (
              BuildContext context, {
              int currentLength,
              int maxLength,
              bool isFocused,
            }) =>
                null,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name of sphere',
                hintStyle: Theme.of(context).textTheme.title),
            cursorColor: JuntoPalette.juntoGrey,
            cursorWidth: 2,
            maxLines: null,
            maxLength: 140,
            style: Theme.of(context).textTheme.title),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: sphereHandleController,
          buildCounter: (
            BuildContext context, {
            int currentLength,
            int maxLength,
            bool isFocused,
          }) =>
              null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Choose a unique username',
              hintStyle: Theme.of(context).textTheme.caption),
          cursorColor: Theme.of(context).primaryColorDark,
          cursorWidth: 2,
          maxLines: null,
          style: Theme.of(context).textTheme.caption,
          maxLength: 80,
          textInputAction: TextInputAction.done,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: sphereDescriptionController,
          // buildCounter: (
          //   BuildContext context, {
          //   int currentLength,
          //   int maxLength,
          //   bool isFocused,
          // }) =>
          //     null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'About your sphere',
              hintStyle: Theme.of(context).textTheme.caption,
              counterStyle:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          cursorColor: Theme.of(context).primaryColorDark,
          cursorWidth: 2,
          maxLines: null,
          style: Theme.of(context).textTheme.caption,
          maxLength: 1000,
          textInputAction: TextInputAction.done,
        ),
      ),
    ]);
  }

  Widget _createSphereTwo() {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  const SizedBox(width: 7.5),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0.0, 2),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          border: InputBorder.none,
                          hintText: 'Add members to your sphere',
                          hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: Theme.of(context).primaryColorDark,
                        cursorWidth: 1,
                        maxLines: null,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Widget _createSphereThree() {
    return ListView(
      children: <Widget>[
        _spherePrivacy('Public',
            'Anyone can join this sphere, read its expressions and share to it'),
        _spherePrivacy(
            'Shared',
            'Only members can read expressions '
                'and share to it. Facilitators can invite members or accept their request to join.'),
        _spherePrivacy(
            'Private',
            'Members must be invited into this sphere. This sphere is only searchable by members.'
                ' Only members can read expressions '),
      ],
    );
  }

  Widget _spherePrivacy(String privacyLayer, String privacyDescription) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPrivacy = privacyLayer;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      privacyLayer,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(privacyDescription,
                        style: Theme.of(context).textTheme.body2)
                  ],
                ),
              ),
              AnimatedContainer(
                duration: kThemeChangeDuration,
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: _currentPrivacy == privacyLayer
                          ? <Color>[
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.primary
                            ]
                          : <Color>[Colors.white, Colors.white],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dynamic _openChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
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
                          color: const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _onPickPressed();
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Text(
                          'Upload new photo',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      setState(() {
                        imageFile = null;
                      });
                      Navigator.pop(context);
                    },
                    title: Row(
                      children: <Widget>[
                        Text(
                          'Remove photo',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
