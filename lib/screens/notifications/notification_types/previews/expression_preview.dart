import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/dynamic_preview.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/shortform_preview.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/photo_preview.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/previews/audio_preview.dart';

class NotificationExpressionPreview extends StatelessWidget {
  const NotificationExpressionPreview({this.item});
  final JuntoNotification item;

  Widget _displayPreview() {
    switch (item.sourceExpression.type) {
      case 'LongForm':
        {
          return NotificationDynamicPreview(item: item);
        }
        break;
      case 'ShortForm':
        {
          return NotificationShortformPreview(item: item);
        }
        break;
      case 'PhotoForm':
        {
          return NotificationPhotoPreview(item: item);
        }
        break;
      case 'AudioForm':
        {
          return NotificationAudioPreview(item: item);
        }
        break;
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 48),
          _displayPreview(),
        ],
      ),
    );
  }
}
