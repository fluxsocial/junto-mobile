import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';

class GlobalInviteIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          Icons.mail_outline,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
