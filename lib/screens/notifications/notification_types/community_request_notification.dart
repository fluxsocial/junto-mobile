import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/user_profile_picture.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/pack_request_response.dart';
import 'package:junto_beta_mobile/screens/notifications/utils/username_text_span.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class CommunityRequestNotification extends StatelessWidget {
  final JuntoNotification item;

  const CommunityRequestNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              UserProfilePicture(item: item),
              const SizedBox(width: 10),
              Flexible(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      children: <TextSpan>[
                        UsernameTextspan(item: item).retrieveTextSpan(context),
                        TextSpan(
                          text: 'invited you to join their community ',
                        ),
                        TextSpan(
                          text: "'${item.group.groupData.name}'",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          if (item.group.groupData.photo.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: MediaQuery.of(context).size.width / 3 * 2 - 68,
                width: MediaQuery.of(context).size.width - 68,
                margin: const EdgeInsets.only(left: 50, top: 20),
                child: ImageWrapper(
                  imageUrl: item.group.groupData.photo,
                  placeholder: (BuildContext context, String _) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: MediaQuery.of(context).size.width / 3 * 2 - 68,
                      width: MediaQuery.of(context).size.width - 68,
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          PackRequestResponse(
            notification: item,
          ),
        ],
      ),
    );
  }
}
