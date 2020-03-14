import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:provider/provider.dart';

class PackOpenMembers extends StatelessWidget {
  const PackOpenMembers({
    Key key,
    this.packAddress,
  }) : super(key: key);
  final String packAddress;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Users>>(
      future: Provider.of<GroupRepo>(context).getGroupMembers(packAddress),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            children: <Widget>[
              for (Users user in snapshot.data)
                MemberPreview(profile: user.user)
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
