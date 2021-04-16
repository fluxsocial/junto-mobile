import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/create_sphere/create_sphere_page_one.dart';
import 'package:junto_beta_mobile/screens/groups/circles/create_sphere/create_sphere_page_two.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';

class CreateSphere extends StatefulWidget {
  const CreateSphere({
    Key key,
  }) : super(key: key);

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

    // create sphere body
    final SphereModel sphere = SphereModel(
      name: sphereName.trim(),
      description: sphereDescription.trim(),
      facilitators: <String>[],
      photo: sphereImageKey,
      members: _sphereMembers,
      principles: '',
      sphereHandle: sphereHandle,
      privacy: _currentPrivacy,
    );

    try {
      final response = await Provider.of<GroupRepo>(context, listen: false)
          .createSphere(sphere);
      context.bloc<CircleBloc>().add(CreateCircleEvent(response));
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      if (error.errorCode == 429) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
              dialogText:
                  'You can only create three public communities on Junto.'),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.message,
          ),
        );
      }
    } on DioError catch (error) {
      JuntoLoader.hide();

      if (error.response.statusCode == 429) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
              dialogText:
                  "For now, you can only create five public communities on Junto. Let us know if you'd like this to change!"),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.response.data['error'].toString(),
          ),
        );
      }
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

  void _validateSphereCreation() {
    if (_formKey.currentState.validate()) {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }

      final exp = RegExp("^[a-z0-9_]+\$");
      if (!exp.hasMatch(sphereHandle.toLowerCase().trim())) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: S.of(context).welcome_username_requirements,
          ),
        );
        return;
      }

      createSphereController.nextPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      return;
    }
  }

  void sphereAddMember(UserProfile member) {
    setState(() {
      if (!_sphereMembers.contains(member.address)) {
        _sphereMembers.add(member.address);
      }
    });
  }

  void _sphereRemoveMember(UserProfile member) {
    setState(() {
      _sphereMembers.remove(member.address);
    });
  }

  Widget _createSphereThree() {
    return ListView(
      children: <Widget>[
        _spherePrivacy('Public',
            'Anyone can join this community, read its expressions, and share to it.'),
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
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
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
                    Text(
                      privacyDescription,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
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
                    end: Alignment.topRight,
                  ),
                  border: Border.all(
                    color: Theme.of(context).backgroundColor,
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
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_currentIndex == 0)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(
                        CustomIcons.newcollective,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Create Community',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_currentIndex != 0)
                GestureDetector(
                  onTap: () {
                    createSphereController.previousPage(
                      curve: Curves.easeIn,
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    color: Colors.transparent,
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      CustomIcons.back,
                      size: 17,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              if (_currentIndex == 2)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: CreateCommunityButton(
                    cta: _createSphere,
                    title: 'Create',
                  ),
                ),
              if (_currentIndex != 2)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: CreateCommunityButton(
                    cta: _onNextPress,
                    title: 'Next',
                  ),
                ),
            ],
          ),
          Container(
            height: .75,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  void _onNextPress() {
    if (_currentIndex == 0) {
      setState(() {
        sphereName = sphereNameController.value.text;
        sphereHandle = sphereHandleController.value.text;
        sphereDescription = sphereDescriptionController.value.text;
      });
      _validateSphereCreation();
      return;
    }
    createSphereController.nextPage(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAppBar(),
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
                        sphereDescriptionController:
                            sphereDescriptionController,
                        sphereHandleController: sphereHandleController,
                        sphereNameController: sphereNameController,
                        imageFile: imageFile,
                      ),
                      CreateSpherePageTwo(
                        addMember: sphereAddMember,
                        removeMember: _sphereRemoveMember,
                        selectedMembers: _sphereMembers,
                      ),
                      _createSphereThree()
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CreateCommunityButton extends StatelessWidget {
  const CreateCommunityButton({
    this.cta,
    this.title,
  });

  final Function cta;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cta,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
