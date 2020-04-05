import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class FetchMoreButton extends StatelessWidget {
  const FetchMoreButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: media.padding.bottom + 60.0,
        top: 12.0,
      ),
      child: FlatButton.icon(
        onPressed: onPressed,
        icon: Icon(CustomIcons.lotus),
        label: Text('More'),
      ),
    );
  }
}
