import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';

/// This class renders the list of spheres a member belongs to. It includes a widget to
/// create a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatelessWidget with ListDistinct {
  const JuntoSpheres({
    Key key,
    @required this.userProfile,
    @required this.userSpheres,
  }) : super(key: key);

  final UserData userProfile;
  final List<Group> userSpheres;

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          for (Group group in userSpheres)
            SpherePreview(
              group: group,
              userProfile: userProfile,
            )
        ],
      ),
    );
  }
}
