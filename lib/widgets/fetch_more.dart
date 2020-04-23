import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class FetchMoreButton extends StatelessWidget {
  const FetchMoreButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: media.padding.bottom + 80.0,
      ),
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: FlatButton.icon(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        icon: Icon(
          CustomIcons.newcreate,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          'View 50 More Expressions'.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
