import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

class CreateSphere extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateSphereState();
  }
}

class CreateSphereState extends State<CreateSphere> {
  File imageFile;
  int _currentIndex = 0;
  PageController createSphereController;
  TextEditingController sphereNameController;
  TextEditingController sphereUsernameController;
  TextEditingController sphereAboutController;

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

  @override
  void initState() {
    createSphereController = PageController();
    sphereNameController = TextEditingController();
    sphereUsernameController = TextEditingController();
    sphereAboutController = TextEditingController();

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
                          width: 48,
                          alignment: Alignment.centerLeft,
                          child: Icon(CustomIcons.back,
                              size: 17,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                Text('Create Sphere',
                    style: Theme.of(context).textTheme.subhead),
                GestureDetector(
                  onTap: () {
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
                children: <Widget>[_createSphereOne(), _createSphereTwo()],
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
          controller: sphereUsernameController,
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
              hintStyle: Theme.of(context).textTheme.headline),
          cursorColor: Theme.of(context).primaryColorDark,
          cursorWidth: 2,
          maxLines: null,
          style: Theme.of(context).textTheme.headline,
          maxLength: 80,
          textInputAction: TextInputAction.done,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: sphereAboutController,
          buildCounter: (
            BuildContext context, {
            int currentLength,
            int maxLength,
            bool isFocused,
          }) =>
              null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'About your sphere',
              hintStyle: Theme.of(context).textTheme.headline),
          cursorColor: Theme.of(context).primaryColorDark,
          cursorWidth: 2,
          maxLines: null,
          style: Theme.of(context).textTheme.headline,
          maxLength: 80,
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
    return SizedBox();
  }

  _openChangePhotoModal() {
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
