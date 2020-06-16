import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:provider/provider.dart';

class PackOpenActionItems extends StatefulWidget {
  const PackOpenActionItems({@required this.pack, this.userProfile});

  final Group pack;
  final UserData userProfile;

  @override
  _PackOpenActionItemsState createState() => _PackOpenActionItemsState();
}

class _PackOpenActionItemsState extends State<PackOpenActionItems> {
  Future<void> leavePack() async {
    await Provider.of<GroupRepo>(context, listen: false).removeGroupMember(
      widget.pack.address,
      widget.userProfile.user.address,
    );
    Navigator.pop(context);
  }

  Future<void> _navigateMember() async {
    final String packCreatorAddress = widget.pack.creator['address'];
    final UserData userData =
        await Provider.of<UserRepo>(context, listen: false)
            .getUser(packCreatorAddress);
    final UserProfile _userProfile = userData.user;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => JuntoMember(profile: _userProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .38,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: _navigateMember,
                  title: Row(
                    children: <Widget>[
                      Text(
                        "'View @' + ${widget.pack.creator['username']}'s den",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ConfirmDialog(
                        buildContext: context,
                        confirm: leavePack,
                        confirmationText:
                            'Are you sure you want to leave this pack?',
                        errorMessage: S.of(context).common_network_error,
                      ),
                    );
                  },
                  title: Row(
                    children: <Widget>[
                      Text(
                        'Leave Pack',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
