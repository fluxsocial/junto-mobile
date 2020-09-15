import 'package:flutter/material.dart';
import 'package:embedly_preview/embedly_preview.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';

class NotificationLinkPreview extends StatelessWidget {
  const NotificationLinkPreview({
    Key key,
    @required this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final String title = item.sourceExpression.expressionData['title'];
    final String caption = item.sourceExpression.expressionData['caption'];
    final OEmbedResponse embedlyResponse =
        OEmbedResponse.fromMap(item.sourceExpression.expressionData['data']);

    return Container(
      width: MediaQuery.of(context).size.width - 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: .5,
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (caption.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.5,
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                ),
              ),
            ),
          OEmbedWidget(
            data: embedlyResponse,
            expanded: false,
            theme: EmbedlyThemeData(
              brightness: Theme.of(context).brightness,
              backgroundColor: Theme.of(context).backgroundColor,
              headingText: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
              subheadingText: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
