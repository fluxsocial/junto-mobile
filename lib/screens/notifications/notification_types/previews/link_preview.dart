import 'package:flutter/material.dart';
import 'package:flutter_peekalink/flutter_peekalink.dart';
import 'package:flutter_peekalink/theme/peekalink_theme_data.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

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
    final PeekalinkResponse embedlyResponse =
        PeekalinkResponse.fromMap(item.sourceExpression.expressionData['data']);

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
              child: CustomParsedText(caption,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  defaultTextStyle: TextStyle(
                    height: 1.5,
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
                  mentionTextStyle: TextStyle(
                    height: 1.5,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  )),
            ),
          PeekalinkWidget(
            data: embedlyResponse,
            expanded: false,
            theme: PeekalinkThemeData(
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
