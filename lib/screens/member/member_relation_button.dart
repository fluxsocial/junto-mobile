import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class MemberRelationButton extends StatelessWidget {
  const MemberRelationButton({this.toggleMemberRelationships});

  final Function toggleMemberRelationships;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleMemberRelationships,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(-9.0, 0),
          child: Icon(
            CustomIcons.infinity,
            size: 8,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
