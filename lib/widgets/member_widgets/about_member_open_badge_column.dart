import 'package:flutter/material.dart';

import 'about_member_open_badge.dart';

class AboutMemberOpenBadgeColumn extends StatelessWidget {
  const AboutMemberOpenBadgeColumn({this.badges});
  final List<dynamic> badges;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          for (String badge in badges) AboutMemberBadge(badge: badge),
        ],
      ),
    );
  }
}
