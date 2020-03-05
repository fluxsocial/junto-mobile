import 'package:flutter/material.dart';

/// Displays an [icon] and [title] in a row. All properties must not be null.
class JuntoDrawerItem extends StatelessWidget {
  const JuntoDrawerItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
  })  : assert(icon != null),
        assert(title != null),
        assert(onTap != null),
        super(key: key);

  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          children: <Widget>[
            icon,
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}

class JuntoDrawerIcon extends StatelessWidget {
  const JuntoDrawerIcon({
    Key key,
    @required this.icon,
    this.size = 24.0,
  }) : super(key: key);
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      alignment: Alignment.centerLeft,
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    );
  }
}
