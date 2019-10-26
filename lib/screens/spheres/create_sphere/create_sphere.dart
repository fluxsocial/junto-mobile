import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective/create_perspective.dart'
    show SelectedUsers;
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere_next.dart';
import 'package:junto_beta_mobile/utils/utils.dart' show AddUserToList;
import 'package:junto_beta_mobile/widgets/search_members_modal.dart';
import 'package:junto_beta_mobile/widgets/user_preview.dart';
import 'package:provider/provider.dart';

// This class renders a widget that enables the user to create a sphere
class CreateSphere extends StatefulWidget {
  @override
  _CreateSphereState createState() => _CreateSphereState();
}

class _CreateSphereState extends State<CreateSphere>
    with AddUserToList<UserProfile> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _principleController;
  Timer debounceTimer;
  ValueNotifier<List<UserProfile>> queriedUsers =
      ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  final ValueNotifier<SelectedUsers> _users =
      ValueNotifier<SelectedUsers>(SelectedUsers());

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _principleController = TextEditingController();
  }

  void _addUser(UserProfile user) {
    _users.value.selection = placeUser(user, _users.value.selection);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _users.notifyListeners();
  }

  void _onTextChange(String value) {
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (mounted) {
        final List<UserProfile> result =
            await Provider.of<SearchProvider>(context).searchMember(value);
        if (result != null && result.isNotEmpty) {
          queriedUsers.value = result;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _principleController.dispose();
    super.dispose();
  }

  Future<void> _createSphere() async {
    final UserProfile _profile =
        await Provider.of<UserService>(context).readLocalUser();
    final String sphereName = _nameController.value.text;
    final String sphereDescription = _descriptionController.value.text;
    final String principleDesc = _principleController.value.text;
    final CentralizedSphere sphere = CentralizedSphere(
      name: sphereName,
      description: sphereDescription,
      facilitators: <String>[
        _profile.address,
      ],
      photo: '',
      members: _users.value.selection
          .map((UserProfile _profile) => _profile.address)
          .toList(growable: false),
      principles: principleDesc,
      sphereHandle: sphereName,
      privacy: '',
    );
    Navigator.of(context).push(CreateSphereNext.route(sphere));
  }

  void _removeSelectedItem(UserProfile profile) {
    _users.value.selection.remove(profile);
    //ignore:, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _users.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: JuntoPalette.juntoSleek,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Colors.white,
                      width: 38,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        CustomIcons.back_arrow_left,
                        color: JuntoPalette.juntoSleek,
                        size: 28,
                      ),
                    )),
                const Text(
                  'Create Sphere',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: _createSphere,
                  child: Container(
                    width: 38,
                    alignment: Alignment.centerRight,
                    child: const Text('next', style: JuntoStyles.body),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: JuntoPalette.juntoFade,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _CreateSphereTextField(
                        key: const Key('name-field-create-sphere'),
                        controller: _nameController,
                        hintText: 'Name your sphere',
                      ),
                      _CreateSphereTextField(
                        key: const Key('Description-field-create-sphere'),
                        controller: _descriptionController,
                        hintText: 'Describe your sphere',
                      ),
                      _CreateSphereTextField(
                        key: const Key('principle-field-create-sphere'),
                        controller: _principleController,
                        hintText: 'Sphere principles',

                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        child: ListenableProvider<
                            ValueNotifier<SelectedUsers>>.value(
                          value: _users,
                          child: SearchMembersModal(
                            onProfileSelected: _addUser,
                            results: queriedUsers,
                            onTextChange: _onTextChange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ValueListenableBuilder<SelectedUsers>(
                        valueListenable: _users,
                        builder:
                            (BuildContext context, SelectedUsers snapshot, _) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.selection.length,
                            itemBuilder: (BuildContext context, int index) {
                              final UserProfile _profile =
                                  snapshot.selection[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Dismissible(
                                  key: ValueKey<UserProfile>(_profile),
                                  background: Material(color: Colors.redAccent),
                                  onDismissed: (_) =>
                                      _removeSelectedItem(_profile),
                                  child: UserPreview(
                                    userProfile: _profile,
                                    onTap: _removeSelectedItem,
                                    showSelectionIndicator: false,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CreateSphereTextField extends StatefulWidget {
  const _CreateSphereTextField({
    Key key,
    @required this.controller,
    @required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  __CreateSphereTextFieldState createState() => __CreateSphereTextFieldState();
}

class __CreateSphereTextFieldState extends State<_CreateSphereTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width - 20,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffeeeeee),
            width: .75,
          ),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        buildCounter: (
          BuildContext context, {
          int currentLength,
          int maxLength,
          bool isFocused,
        }) =>
            null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xff999999),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        cursorColor: const Color(0xff333333),
        cursorWidth: 2,
        maxLines: null,
        style: const TextStyle(
            color: Color(0xff333333),
            fontSize: 20,
            fontWeight: FontWeight.w700),
        maxLength: 80,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
