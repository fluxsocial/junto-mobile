import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/groups/circles/create_sphere/create_sphere_page_two.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';

class SphereAddMembers extends StatefulWidget {
  final Group group;
  final String permission;
  final List<Users> members;
  const SphereAddMembers({
    Key key,
    this.group,
    this.permission,
    this.members,
  }) : super(key: key);

  @override
  _SphereAddMembersState createState() => _SphereAddMembersState();
}

class _SphereAddMembersState extends State<SphereAddMembers> {
  List<UserProfile> _sphereMembers = <UserProfile>[];

  bool _sphereAddMember(UserProfile member) {
    final List<String> groupMembers = [];
    widget.members.forEach(
      (groupMember) {
        groupMembers.add(groupMember.user.address);
      },
    );
    if (groupMembers.contains(member.address)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          context: context,
          dialogText: 'This member is already a part of this group.',
        ),
      );
      return false;
    }

    if (member.address == widget.group.creator) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          context: context,
          dialogText: 'This member is already a part of this group',
        ),
      );

      return false;
    }
    setState(() {
      final contain =
          _sphereMembers.where((element) => element.address == member.address);
      if (contain.isEmpty) {
        _sphereMembers.add(member);
      }
    });
    return true;
  }

  void _sphereRemoveMember(UserProfile member) {
    setState(() {
      _sphereMembers = _sphereMembers
          .where((element) => element.address != member.address)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(
      builder: (context, state) {
        if (state is CircleLoaded) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: AppBar(
                automaticallyImplyLeading: false,
                brightness: Theme.of(context).brightness,
                elevation: 0,
                titleSpacing: 0,
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          color: Colors.transparent,
                          width: 42,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            CustomIcons.back,
                            color: Theme.of(context).primaryColorDark,
                            size: 17,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Invite Members',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      if (_sphereMembers.length == 0)
                        const SizedBox(width: 48)
                      else
                        GestureDetector(
                          onTap: () async {
                            try {
                              JuntoLoader.showLoader(context);
                              context.bloc<CircleBloc>().add(
                                    AddMemberToCircle(
                                      sphereAddress: widget.group.address,
                                      user: _sphereMembers,
                                      permissionLevel: widget.permission,
                                    ),
                                  );
                              JuntoLoader.hide();

                              showDialog(
                                context: context,
                                child: SingleActionDialog(
                                  context: context,
                                  dialogText: 'Your community invite was sent!',
                                ),
                              );

                              setState(() {
                                _sphereMembers = [];
                              });
                            } on DioError catch (e) {
                              print(e.response.data);
                            } catch (e) {
                              JuntoLoader.hide();
                              showDialog(
                                context: context,
                                child: SingleActionDialog(
                                  context: context,
                                  dialogText:
                                      'Sorry, something went wrong. Try again!',
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
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
            body: CreateSpherePageTwo(
              addMember: _sphereAddMember,
              removeMember: _sphereRemoveMember,
              selectedMembers: _sphereMembers.map((e) => e.address).toList(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
