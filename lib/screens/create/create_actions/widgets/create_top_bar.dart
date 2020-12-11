import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class CreateTopBar extends StatelessWidget {
  const CreateTopBar({this.profilePicture});

  final List<dynamic> profilePicture;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      child: Row(
        children: [
          MemberAvatar(
            diameter: 33,
            profilePicture: profilePicture,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text(
                    'Collective',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 12,
                  color: Theme.of(context).primaryColorLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
