import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/user_profile_picture.dart';
import 'package:junto_beta_mobile/screens/notifications/utils/username_text_span.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/expression_preview.dart';

class MentionNotification extends StatelessWidget {
  final JuntoNotification item;

  const MentionNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(item);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // UserProfilePicture(item: item),
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
                        TextSpan(text: 'mentioned you in an expression.'),
                      ]),
                ),
              ),
            ],
          ),
          // NotificationExpressionPreview(item: item),
        ],
      ),
    );
  }
}
