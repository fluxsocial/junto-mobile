import 'package:flutter/material.dart';

class PackName extends StatelessWidget {
  const PackName({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(right: 20),
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
