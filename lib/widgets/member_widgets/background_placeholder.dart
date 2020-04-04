import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberBackgroundPlaceholder extends StatelessWidget {
  const MemberBackgroundPlaceholder({this.theme});

  final String theme;

  String _getBackgroundImageAsset() {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        _getBackgroundImageAsset(),
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
