import 'dart:io';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/create_sphere/create_sphere_page_one.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/create_sphere/create_sphere_page_two.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSphere extends StatefulWidget {
  const CreateSphere({
    Key key,
    @required this.refreshSpheres,
  }) : super(key: key);
  final Function refreshSpheres;

  @override
  State<StatefulWidget> createState() {
    return CreateSphereState();
  }
}

class CreateSphereState extends State<CreateSphere> {
  ValueNotifier<File> imageFile = ValueNotifier<File>(null);
  int _currentIndex = 0;
  String sphereName;
  String sphereHandle;
  String sphereDescription;

  PageController createSphereController;
  TextEditingController sphereNameController;
  TextEditingController sphereHandleController;
  TextEditingController sphereDescriptionController;
  String _currentPrivacy = 'Public';

  GlobalKey<FormState> _formKey;

  final List<String> _sphereMembers = <String>[];
  final List<String> _tabs = <String>['Subscriptions', 'Connections'];
  final AsyncMemoizer<Map<String, dynamic>> _memoizer =
      AsyncMemoizer<Map<String, dynamic>>();

  Future<void> _createSphere() async {
    JuntoLoader.showLoader(context);

    // instantiate sphere image key
    String sphereImageKey = '';

    // check if user uploaded a photo for the sphere
    if (imageFile.value != null) {
      try {
        final String _photoKey =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto(true, '.png', imageFile.value);
        sphereImageKey = _photoKey;
      } catch (error) {
        print(error);
        JuntoLoader.hide();
      }
    }

    // get user address from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userAddress = await prefs.get('user_id');

    // create sphere body
    final SphereModel sphere = SphereModel(
      name: sphereName,
      description: sphereDescription,
      facilitators: <String>[userAddress],
      photo: sphereImageKey,
      members: _sphereMembers,
      principles: '',
      sphereHandle: sphereHandle,
      privacy: _currentPrivacy,
    );

    try {
      await Provider.of<GroupRepo>(context, listen: false).createSphere(sphere);
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

  @override
  void initState() {
    super.initState();
    createSphereController = PageController();
    sphereNameController = TextEditingController();
    sphereHandleController = TextEditingController();
    sphereDescriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    createSphereController.dispose();
    sphereNameController.dispose();
    sphereHandleController.dispose();
    sphereDescriptionController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getUserRelationships() async {
    return _memoizer.runOnce(
      () => Provider.of<UserRepo>(context, listen: false).userRelations(),
    );
  }

  void _validateSphereCreation() {
    if (_formKey.currentState.validate()) {
      createSphereController.nextPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      JuntoDialog.showJuntoDialog(
        context,
        'Please ensure all fields are filled',
        <Widget>[
          DialogBack(),
        ],
      );
    }
  }

  void _sphereAddMember(UserProfile member) {
    _sphereMembers.add(member.address);
  }

  void _sphereRemoveMember(UserProfile member) {
    _sphereMembers.remove(member.address);
  }

  Widget _createSphereThree() {
    return ListView(
      children: <Widget>[
        _spherePrivacy('Public',
            'Anyone can join this sphere, read its expressions and share to it'),
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(privacyDescription,
                        style: Theme.of(context).textTheme.bodyText1)
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

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_currentIndex == 0)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Colors.transparent,
                  width: 48,
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    CustomIcons.back,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            if (_currentIndex != 0)
              GestureDetector(
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
                      size: 17, color: Theme.of(context).primaryColorDark),
                ),
              ),
            if (_currentIndex == 0)
              Text(
                'Create Circle',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            if (_currentIndex == 2)
              GestureDetector(
                onTap: _createSphere,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 10),
                  width: 60,
                  alignment: Alignment.centerRight,
                  child: Text('create',
                      style: Theme.of(context).textTheme.caption),
                ),
              ),
            if (_currentIndex != 2)
              GestureDetector(
                onTap: () {
                  if (_currentIndex == 0) {
                    setState(() {
                      sphereName = sphereNameController.value.text;
                      sphereHandle = sphereHandleController.value.text;
                      sphereDescription =
                          sphereDescriptionController.value.text;
                    });
                  }
                  _validateSphereCreation();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 10),
                  width: 48,
                  alignment: Alignment.centerRight,
                  child:
                      Text('next', style: Theme.of(context).textTheme.caption),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: _buildAppBar(),
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
                  CreateSpherePageOne(
                    formKey: _formKey,
                    sphereDescriptionController: sphereDescriptionController,
                    sphereHandleController: sphereHandleController,
                    sphereNameController: sphereNameController,
                    imageFile: imageFile,
                  ),
                  CreateSpherePageTwo(
                    future: getUserRelationships(),
                    addMember: _sphereAddMember,
                    removeMember: _sphereRemoveMember,
                    tabs: _tabs,
                  ),
                  _createSphereThree()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
