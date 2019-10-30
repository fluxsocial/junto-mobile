import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

/// This class renders the main screen for Spheres. It includes a widget to
/// create a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatefulWidget {
  const JuntoSpheres({Key key, @required this.userProfile,})
      : super(key: key);

  final UserProfile userProfile;

  @override
  State<StatefulWidget> createState() => JuntoSpheresState();
}

class JuntoSpheresState extends State<JuntoSpheres> with ListDistinct {
  UserService _userProvider;
  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserService>(context);
  }

  Widget buildError() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Text(
        'Oops, something is wrong!',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => _userProvider.getUserGroups(widget.userProfile.address),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: <Widget>[
          FutureBuilder<UserGroupsResponse>(
            future: getUserGroups(),
            builder: (BuildContext context,
                AsyncSnapshot<UserGroupsResponse> snapshot) {
              if (snapshot.hasError) {
                return buildError();
              }
              if (snapshot.hasData && !snapshot.hasError) {
                final List<Group> ownedGroups = snapshot.data.owned;
                final List<Group> associatedGroups = snapshot.data.associated;
                final List<Group> userGroups =
                    distinct<Group>(ownedGroups, associatedGroups)
                        .where((Group group) => group.groupType == 'Sphere')
                        .toList();
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    for (Group group in userGroups)
                      SpherePreview(
                        group: group,
                      ),
                  ],
                );
              }

              return Container(
                height: 100.0,
                width: 100.0,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
