import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 14),
            Image.asset(
              'assets/images/junto-mobile__infinity.png',
              height: 14,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 12,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
