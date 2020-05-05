import 'package:flutter/material.dart';

class NotificationTabName extends StatelessWidget {
  const NotificationTabName({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 20,
      ),
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
