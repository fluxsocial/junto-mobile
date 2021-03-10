import 'package:flutter/material.dart';

class AboutMemberBadge extends StatelessWidget {
  const AboutMemberBadge({this.badge});

  final String badge;

  _buildBadge() {
    Map<String, String> badgeInfo = {};
    String badgeAsset;
    String badgeName;
    switch (badge) {
      case 'Gold':
        badgeAsset = 'assets/images/junto-mobile__badge--gold.png';
        badgeName = 'Gold Sponsor';
        break;

      case 'Silver':
        badgeAsset = 'assets/images/junto-mobile__badge--silver.png';
        badgeName = 'Silver Sponsor';
        break;
      case 'Platinum':
        badgeAsset = 'assets/images/junto-mobile__badge--platinum.png';
        badgeName = 'Platinum Sponsor';
        break;
      case 'Crowdfunder':
        badgeAsset = 'assets/images/junto-mobile__badge--crowdfunder.png';
        badgeName = 'Crowdfunder';
        break;
      default:
        badgeAsset = 'assets/images/junto-mobile__badge--crowdfunder.png';
        badgeName = 'Crowdfunder';
        break;
    }
    badgeInfo = {
      'asset': badgeAsset,
      'name': badgeName,
    };
    return badgeInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset(
            _buildBadge()['asset'],
            height: 20,
          ),
          const SizedBox(width: 5),
          Text(
            _buildBadge()['name'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
