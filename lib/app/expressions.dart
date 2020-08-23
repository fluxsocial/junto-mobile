import 'package:flutter/material.dart';

import 'custom_icons.dart';

enum ExpressionType { dynamic, shortform, photo, event, audio, linkform }

extension ExpressionIcon on ExpressionType {
  IconData icon() {
    final Map<ExpressionType, IconData> _expressionIcon = {
      ExpressionType.dynamic: CustomIcons.longform,
      ExpressionType.shortform: CustomIcons.feather,
      ExpressionType.photo: CustomIcons.camera,
      ExpressionType.event: CustomIcons.event,
      ExpressionType.audio: Icons.mic,
      ExpressionType.linkform: Icons.link,
    };
    return _expressionIcon[this];
  }

  String name() {
    final Map<ExpressionType, String> _expressionNames = {
      ExpressionType.dynamic: 'DYNAMIC',
      ExpressionType.shortform: 'SHORTFORM',
      ExpressionType.photo: 'PHOTO',
      ExpressionType.event: 'EVENT',
      ExpressionType.audio: 'AUDIO',
      ExpressionType.linkform: 'LINK',
    };
    return _expressionNames[this];
  }

  String appBarName() {
    final Map<ExpressionType, String> _expressionAppBarNames = {
      ExpressionType.dynamic: 'dynamic',
      ExpressionType.shortform: 'shortform',
      ExpressionType.photo: 'photo',
      ExpressionType.event: 'event',
      ExpressionType.audio: 'audio',
    };

    return _expressionAppBarNames[this];
  }

  String modelName() {
    final Map<ExpressionType, String> _expressionModelNames = {
      ExpressionType.dynamic: 'LongForm',
      ExpressionType.shortform: 'ShortForm',
      ExpressionType.photo: 'PhotoForm',
      ExpressionType.event: 'EventForm',
      ExpressionType.audio: 'AudioForm',
      ExpressionType.linkform: 'LinkForm',
    };

    return _expressionModelNames[this];
  }
}
