import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere_next.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/utils/utils.dart' show AddUserToList;
import 'package:junto_beta_mobile/widgets/search_members_modal.dart';
import 'package:provider/provider.dart';

// This class renders a widget that enables the user to create a sphere
class CreateSphere extends StatefulWidget {
  @override
  _CreateSphereState createState() => _CreateSphereState();
}

class _CreateSphereState extends State<CreateSphere> with AddUserToList {
  TextEditingController _textEditingController;
  Timer debounceTimer;
  ValueNotifier<List<UserProfile>> queriedUsers =
      ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  List<String> _selectedUsers = <String>[];

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _addUser(UserProfile user) {
    _selectedUsers = placeUser(user.address, _selectedUsers);
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
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _createSphere() async {
    final UserProfile _profile =
        await Provider.of<UserProvider>(context).readLocalUser();
    final String sphereName = _textEditingController.value.text;
    final CentralizedSphere sphere = CentralizedSphere(
      name: sphereName,
      description: '',
      facilitators: <String>[
        _profile.address,
      ],
      photo: '',
      members: _selectedUsers,
      principles: "Don't be a horrible human being",
      sphereHandle: sphereName,
      privacy: '',
    );
    Navigator.of(context).push(CreateSphereNext.route(sphere));
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
                    child: Text('next', style: JuntoStyles.body),
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
                      Container(
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
                          controller: _textEditingController,
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name your sphere',
                            hintStyle: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
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
                        child: SearchMembersModal(
                          onProfileSelected: _addUser,
                          results: queriedUsers,
                          onTextChange: _onTextChange,
                        ),
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
