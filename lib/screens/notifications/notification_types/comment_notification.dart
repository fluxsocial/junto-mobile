import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/user_profile_picture.dart';
import 'package:junto_beta_mobile/screens/notifications/utils/username_text_span.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/dynamic_preview.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/shortform_preview.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/photo_preview.dart';

class CommentNotification extends StatelessWidget {
  final JuntoNotification item;

  const CommentNotification({Key key, this.item}) : super(key: key);
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
                        TextSpan(text: 'commented on your expression.'),
                      ]),
                ),
              ),
            ],
          ),
          if (item.sourceExpression.type == 'LongForm')
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 48),
                  NotificationDynamicPreview(item: item),
                ],
              ),
            ),
          if (item.sourceExpression.type == 'ShortForm')
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 48),
                  NotificationShortformPreview(item: item),
                ],
              ),
            ),
          if (item.sourceExpression.type == 'PhotoForm')
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 48),
                  NotificationPhotoPreview(item: item),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
