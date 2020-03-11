import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';

class PackOpenMembers extends StatelessWidget {
  const PackOpenMembers({this.getPackMembers});

  final Future<List<Users>> getPackMembers;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Users>>(
        future: getPackMembers,
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
        });
  }
}
