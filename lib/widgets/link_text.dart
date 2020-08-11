import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class LinkText extends StatelessWidget {
  const LinkText(
    this.text, {
    Key key,
    this.style,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;

  Future<void> onLinkPressed(LinkableElement element) async {
    if (await canLaunch(element.url)) {
      await launch(element.url);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: onLinkPressed,
      text: text,
      linkStyle: style,
      style: style,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
