import 'package:flutter/material.dart';

class MemberBadgeItem extends StatelessWidget {
  const MemberBadgeItem({this.badge});

  final String badge;

  _buildBadge() {
    switch (badge) {
      case 'Gold':
        return 'assets/images/junto-mobile__badge--gold.png';
      case 'Silver':
        return 'assets/images/junto-mobile__badge--silver.png';
      case 'Platinum':
        return 'assets/images/junto-mobile__badge--platinum.png';
      case 'Crowdfunder':
        return 'assets/images/junto-mobile__badge--crowdfunder.png';
      default:
        return 'assets/images/junto-mobile__badge--crowdfunder.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      child: Image.asset(
        _buildBadge(),
        height: 28,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
