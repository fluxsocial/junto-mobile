import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/providers/user_provider.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/search_members_modal.dart';
import 'package:provider/provider.dart';

class SelectedUsers {
  List<String> selection = <String>[];
}

class CreatePerspective extends StatefulWidget {
  @override
  _CreatePerspectiveState createState() => _CreatePerspectiveState();
}

class _CreatePerspectiveState extends State<CreatePerspective> with AddUserToList, ChangeNotifier {
  TextEditingController controller;
  Timer debounceTimer;
  ValueNotifier<List<UserProfile>> queriedUsers = ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  final ValueNotifier<SelectedUsers> _users = ValueNotifier<SelectedUsers>(SelectedUsers());

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTextChange(String value) {
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (mounted) {
        final List<UserProfile> result = await Provider.of<SearchProvider>(context).searchMember(value);
        if (result != null && result.isNotEmpty) {
          queriedUsers.value = result;
        }
      }
    });
  }

  Future<void> createPerspective() async {
    final String name = controller.value.text;
    JuntoOverlay.showLoader(context);
    try {
      await Provider.of<UserProvider>(context).createPerspective(Perspective(name: name));
      JuntoOverlay.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      );
    }
  }

  void _onUserSelected(UserProfile value) {
    _users.value.selection = placeUser(value.address, _users.value.selection);
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    CustomIcons.back_arrow_left,
                    color: JuntoPalette.juntoSleek,
                    size: 24,
                  ),
                ),
                const Text(
                  'New Perspective',
                  style: TextStyle(fontSize: 15, color: Color(0xff333333), fontWeight: FontWeight.w700),
                ),
                InkWell(
                  onTap: () {
                    if (controller.value.text != '') {
                      createPerspective();
                    } else {
                      return;
                    }
                  },
                  enableFeedback: false,
                  child: const Text(
                    'create',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xffeeeeee),
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
                          controller: controller,
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name your perspective',
                            hintStyle: TextStyle(color: Color(0xff999999), fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          cursorColor: const Color(0xff333333),
                          cursorWidth: 2,
                          maxLines: null,
                          style: const TextStyle(color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w700),
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
                        child: ListenableProvider<ValueNotifier<SelectedUsers>>.value(
                          value: _users,
                          child: SearchMembersModal(
                            onTextChange: _onTextChange,
                            results: queriedUsers,
                            onProfileSelected: _onUserSelected,
                          ),
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
