import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/search_members_modal.dart';
import 'package:junto_beta_mobile/widgets/user_preview.dart';
import 'package:provider/provider.dart';

class SelectedUsers extends ChangeNotifier {
  List<UserProfile> selection = <UserProfile>[];
}

@Deprecated('Deprecated in favor of lib/screens/collective/perspectives.dart')
class CreatePerspective extends StatefulWidget {
  @override
  _CreatePerspectiveState createState() => _CreatePerspectiveState();
}

@Deprecated('Deprecated in favor of lib/screens/collective/perspectives.dart')
class _CreatePerspectiveState extends State<CreatePerspective>
    with AddUserToList<UserProfile> {
  TextEditingController controller;
  Timer debounceTimer;
  ValueNotifier<List<UserProfile>> queriedUsers =
      ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  final ValueNotifier<SelectedUsers> _users =
      ValueNotifier<SelectedUsers>(SelectedUsers());

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
      //FIXME(Nash+Yang): Rework search
      // if (mounted) {
      //   final List<UserProfile> result =
      //       await Provider.of<SearchService>(context).searchMembers(value);
      //   if (result != null && result.isNotEmpty) {
      //     queriedUsers.value = result;
      //   }
      // }
    });
  }

  void _removeSelectedItem(UserProfile profile) {
    _users.value.selection.remove(profile);
    //ignore:, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _users.notifyListeners();
  }

  Future<void> createPerspective() async {
    final String name = controller.value.text;
    final String about = controller.value.text;
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<UserRepo>(context).createPerspective(
        Perspective(
          name: name,
          members: <String>[],
          about: about,
        ),
      );
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
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
    _users.value.selection = placeUser(value, _users.value.selection);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
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
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 34.0,
                  child: FlatButton(
                    onPressed: () {
                      if (controller.value.text != '') {
                        createPerspective();
                      } else {
                        return;
                      }
                    },
                    child: const Text(
                      'create',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14,
                      ),
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
                      // About field.
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                        child: ListenableProvider<
                            ValueNotifier<SelectedUsers>>.value(
                          value: _users,
                          //FIXME(Nash): Revisit child param
                          child: SearchMembersModal(
                            onTextChange: _onTextChange,
                            results: queriedUsers,
                            onProfileSelected: _onUserSelected,
                            child: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                ValueListenableBuilder<SelectedUsers>(
                  valueListenable: _users,
                  builder: (BuildContext context, SelectedUsers snapshot, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.selection.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserProfile _profile = snapshot.selection[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Dismissible(
                            key: ValueKey<UserProfile>(_profile),
                            background: Material(color: Colors.redAccent),
                            onDismissed: (_) => _removeSelectedItem(_profile),
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
    );
  }
}
