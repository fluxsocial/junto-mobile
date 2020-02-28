import 'dart:io';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
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
  File imageFile;
  int _currentIndex = 0;
  String sphereName;
  String sphereHandle;
  String sphereDescription;

  PageController createSphereController;
  TextEditingController sphereNameController;
  TextEditingController sphereHandleController;
  TextEditingController sphereDescriptionController;
  String _currentPrivacy = 'Public';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _sphereMembers = <String>[];
  final List<String> _tabs = <String>['Subscriptions', 'Connections'];
  final AsyncMemoizer<Map<String, dynamic>> _memoizer =
      AsyncMemoizer<Map<String, dynamic>>();

  Future<void> _createSphere() async {
    JuntoLoader.showLoader(context);

    // instantiate sphere image key
    String sphereImageKey = '';

    // check if user uploaded a photo for the sphere
    if (imageFile != null) {
      try {
        final String _photoKey =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto(true, '.png', imageFile);
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
    final CentralizedSphere sphere = CentralizedSphere(
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
      widget.refreshSpheres();
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
                'Create Sphere',
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
                  _CreateSpherePageOne(
                    formKey: _formKey,
                    sphereDescriptionController: sphereDescriptionController,
                    sphereHandleController: sphereHandleController,
                    sphereNameController: sphereNameController,
                  ),
                  _CreateSpherePageTwo(
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
        // _spherePrivacy(
        //     'Shared',
        //     'Only members can read expressions '
        //         'and share to it. Facilitators can invite members or accept their request to join.'),
        // _spherePrivacy(
        //     'Private',
        //     'Members must be invited into this sphere. This sphere is only searchable by members.'
        //         ' Only members can read expressions '),
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
}

class _CreateSpherePageOne extends StatefulWidget {
  const _CreateSpherePageOne({
    Key key,
    @required this.formKey,
    @required this.sphereNameController,
    @required this.sphereHandleController,
    @required this.sphereDescriptionController,
    @required this.imageFile,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final TextEditingController sphereNameController;
  final TextEditingController sphereHandleController;
  final TextEditingController sphereDescriptionController;
  final ValueNotifier<File> imageFile;

  @override
  __CreateSpherePageOneState createState() => __CreateSpherePageOneState();
}

class __CreateSpherePageOneState extends State<_CreateSpherePageOne> {
  File get imageFile => widget.imageFile.value;

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() => widget.imageFile.value = null);
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '3:2',
    ]);
    if (cropped == null) {
      setState(() => widget.imageFile.value = null);
      return;
    }
    setState(() => widget.imageFile.value = cropped);
  }

  void _openChangePhotoModal() {
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
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      setState(() {
                        widget.imageFile.value = null;
                      });
                      Navigator.pop(context);
                    },
                    title: Row(
                      children: <Widget>[
                        Text(
                          'Remove photo',
                          style: Theme.of(context).textTheme.headline5,
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidate: true,
      child: ListView(
        children: <Widget>[
          if (imageFile == null)
            GestureDetector(
              onTap: _onPickPressed,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Icon(
                  CustomIcons.camera,
                  size: 38,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          if (imageFile != null)
            Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
              GestureDetector(
                onTap: _openChangePhotoModal,
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereNameController,
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
                  hintStyle: Theme.of(context).textTheme.subtitle1),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              maxLines: null,
              maxLength: 140,
              style: Theme.of(context).textTheme.headline6,
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereHandleController,
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Unique username',
                  hintStyle: Theme.of(context).textTheme.caption),
              cursorColor: Theme.of(context).primaryColorDark,
              cursorWidth: 2,
              maxLines: null,
              style: Theme.of(context).textTheme.caption,
              maxLength: 80,
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereDescriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'About sphere',
                hintStyle: Theme.of(context).textTheme.caption,
                counterStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              cursorColor: Theme.of(context).primaryColorDark,
              cursorWidth: 2,
              maxLines: null,
              style: Theme.of(context).textTheme.caption,
              maxLength: 1000,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateSpherePageTwo extends StatelessWidget {
  const _CreateSpherePageTwo({
    Key key,
    @required this.tabs,
    @required this.future,
    @required this.addMember,
    @required this.removeMember,
  }) : super(key: key);
  final List<String> tabs;
  final Future<Map<String, dynamic>> future;
  final ValueChanged<UserProfile> addMember;
  final ValueChanged<UserProfile> removeMember;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: JuntoAppBarDelegate(
                TabBar(
                  labelPadding: const EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: Theme.of(context).primaryColorDark,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  indicatorWeight: 0.0001,
                  tabs: <Widget>[
                    for (String name in tabs)
                      Container(
                        margin: const EdgeInsets.only(right: 24),
                        color: Theme.of(context).colorScheme.background,
                        child: Tab(
                          text: name,
                        ),
                      ),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: FutureBuilder<Map<String, dynamic>>(
          future: future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              // get list of connections
              final List<UserProfile> _connectionsMembers =
                  snapshot.data['connections']['results'];

              // get list of following
              final List<UserProfile> _followingMembers =
                  snapshot.data['following']['results'];

              return TabBarView(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      for (UserProfile member in _followingMembers)
                        MemberPreviewSelect(
                          profile: member,
                          onSelect: addMember,
                          onDeselect: removeMember,
                        ),
                    ],
                  ),
                  // connections
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      for (UserProfile connection in _connectionsMembers)
                        MemberPreviewSelect(
                          profile: connection,
                          onSelect: addMember,
                          onDeselect: removeMember,
                        ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ),
                  Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ),
                ],
              );
            }
            return TabBarView(
              children: <Widget>[
                Center(
                  child: JuntoProgressIndicator(),
                ),
                Center(
                  child: JuntoProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
