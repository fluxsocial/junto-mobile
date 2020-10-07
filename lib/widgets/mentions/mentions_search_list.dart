import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';

class MentionsSearchList extends StatelessWidget {
  const MentionsSearchList({
    this.userList,
    this.onMentionAdd,
  });

  final List<Map<String, dynamic>> userList;
  final Function onMentionAdd;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .3,
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: userList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MemberPreview(
              onUserTap: () {
                onMentionAdd(index);
              },
              profile: UserProfile(
                username: userList[index]['display'],
                address: userList[index]['id'],
                profilePicture: [userList[index]['photo']],
                name: userList[index]['full_name'],
                verified: true,
                backgroundPhoto: userList[index]['backgroundPhoto'],
                badges: [],
                gender: [],
                website: [],
                bio: userList[index]['bio'],
                location: [],
              ),
            );
          },
        ),
      ),
    );
  }
}
