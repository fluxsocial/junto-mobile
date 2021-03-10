import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/groups/circles/create_sphere/create_sphere_page_two.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

class SphereAddMembers extends StatefulWidget {
  final Group group;
  final String permission;

  const SphereAddMembers({
    Key key,
    this.group,
    this.permission,
  }) : super(key: key);

  @override
  _SphereAddMembersState createState() => _SphereAddMembersState();
}

class _SphereAddMembersState extends State<SphereAddMembers> {
  List<UserProfile> _sphereMembers = <UserProfile>[];

  void _sphereAddMember(UserProfile member) {
    setState(() {
      final contain =
          _sphereMembers.where((element) => element.address == member.address);
      if (contain.isEmpty) {
        _sphereMembers.add(member);
      }
    });
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
                          'Invite Member',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      if (_sphereMembers.length == 0)
                        const SizedBox(width: 48)
                      else
                        GestureDetector(
                          onTap: () {
                            context.read<CircleBloc>().add(
                                  AddMemberToCircle(
                                    sphereAddress: widget.group.address,
                                    user: _sphereMembers,
                                    permissionLevel: widget.permission,
                                  ),
                                );

                            showDialog(
                              context: context,
                              builder: (context) => SingleActionDialog(
                                context: context,
                                dialogText: 'Invitation sent to members',
                              ),
                            );

                            setState(() {
                              _sphereMembers = [];
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(right: 10),
                            width: 48,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Add',
                              style: Theme.of(context).textTheme.caption,
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
