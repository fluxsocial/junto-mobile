import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

class CreateTopBar extends StatelessWidget {
  const CreateTopBar({
    this.profilePicture,
    this.toggleSocialContextVisibility,
    this.currentExpressionContext,
    this.selectedGroup,
    this.hideContextSelector = false,
  });

  final List<dynamic> profilePicture;
  final Function toggleSocialContextVisibility;
  final ExpressionContext currentExpressionContext;
  final Group selectedGroup;
  final bool hideContextSelector;

  String _currentExpressionContext() {
    String socialContext;
    switch (currentExpressionContext) {
      case ExpressionContext.Collective:
        socialContext = 'Collective';
        break;
      case ExpressionContext.MyPack:
        socialContext = 'My Pack';
        break;
      case ExpressionContext.Group:
        socialContext = selectedGroup != null
            ? 'Group - ${selectedGroup.groupData.name}'
            : 'Group';
        break;
      case ExpressionContext.CommunityCenter:
        socialContext = 'Community Center';
        break;
      default:
        socialContext = 'Collective';
        break;
    }
    return socialContext;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toggleSocialContextVisibility(true);
      },
      child: Container(
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
            if (!hideContextSelector)
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
                        _currentExpressionContext(),
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
      ),
    );
  }
}
