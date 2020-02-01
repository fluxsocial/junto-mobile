import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/create_perspective/create_perspective.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/search_members_modal.dart';
import 'package:provider/provider.dart';

class SphereOpenMembers extends StatefulWidget {
  const SphereOpenMembers({
    Key key,
    @required this.users,
    @required this.group,
  }) : super(key: key);

  final List<Users> users;
  final Group group;

  static Route<dynamic> route(Group group, List<Users> users) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return SphereOpenMembers(
          users: users,
          group: group,
        );
      },
    );
  }

  @override
  _SphereOpenMembersState createState() => _SphereOpenMembersState();
}

class _SphereOpenMembersState extends State<SphereOpenMembers>
    with AddUserToList<UserProfile> {
  ValueNotifier<List<UserProfile>> queriedUsers =
      ValueNotifier<List<UserProfile>>(<UserProfile>[]);
  Timer debounceTimer;
  final ValueNotifier<SelectedUsers> _users =
      ValueNotifier<SelectedUsers>(SelectedUsers());

  Future<void> removeMember(BuildContext context, Users user) async {
    final GroupRepo groupRepo = Provider.of<GroupRepo>(context);
    try {
      await groupRepo.removeGroupMember(
          widget.group.address, user.user.address);
      Navigator.pop(context);
    } on JuntoException catch (error) {
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

//ignore:unused_element
  Future<void> _deleteMember(BuildContext context, Users user) async {
    print('User perms level ${user.permissionLevel}');
    JuntoDialog.showJuntoDialog(
      context,
      'Delete Member ${user.user.name}',
      <Widget>[
        FlatButton(
          onPressed: () => removeMember(context, user),
          child: const Text('Yes'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
    );
  }

  void _onTextChange(String value) {
    if (debounceTimer != null) {
      debounceTimer.cancel();
    }
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (mounted) {
      //   final List<UserProfile> result =
      //       await Provider.of<SearchService>(context).searchMember(value);
      //   if (result != null && result.isNotEmpty) {
      //     queriedUsers.value = result;
      //   }
      // }
    });
  }

  void _addUser(UserProfile user) {
    _users.value.selection = placeUser(user, _users.value.selection);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _users.notifyListeners();
  }

  Future<void> _addGroupMember() async {
    Provider.of<GroupRepo>(context)
        .addGroupMember(widget.group.address, _users.value.selection, 'Member');
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.transparent,
                    width: 38,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text('Members',
                      style: Theme.of(context).textTheme.subtitle1),
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
                      onProfileSelected: _addUser,
                      child: Container(
                        width: 38,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.add,
                            size: 24,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ),
                ),
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
                    width: .75,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ValueListenableBuilder<SelectedUsers>(
              valueListenable: _users,
              builder: (BuildContext context, SelectedUsers value, _) {
                if (value.selection.isNotEmpty)
                  return FlatButton(
                    onPressed: _addGroupMember,
                    child: const Text('Add Selected Members'),
                  );
                return const SizedBox();
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.users.length,
              itemBuilder: (BuildContext context, int index) {
                //ignore:unused_local_variable
                final Users user = widget.users[index];
                return const SizedBox();
                // return PerspectiveMemberPreview(
                //   key: Key(user.user.address),
                //   onTap: () {
                //     Navigator.of(context).push(JuntoMember.route(user.user));
                //   },
                //   name: '${user.user.name}',
                //   username: user.user.username,
                //   showIndicator: false,
                //   onLongPress: () => _deleteMember(context, user),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
