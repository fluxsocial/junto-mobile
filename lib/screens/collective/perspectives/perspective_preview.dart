import 'package:flutter/material.dart';

/// Shows a preview of a `Perspective`. The params [title] and
/// [changePerspective] must be supplied.
class PerspectivePreview extends StatelessWidget {
  const PerspectivePreview({
    Key key,
    @required this.title,
    @required this.changePerspective,
  }) : super(key: key);

  /// The name of given perspective
  final String title;

  /// Callback for changing perspectives. Exposes the title of the perspective
  /// tapped by the user.
  final ValueChanged<String> changePerspective;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          changePerspective(title);
          Navigator.pop(context);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Icon(
              Icons.edit,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
