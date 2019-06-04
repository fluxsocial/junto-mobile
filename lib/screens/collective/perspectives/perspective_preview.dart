import 'package:flutter/material.dart';

class PerspectivePreview extends StatelessWidget {
  String title;
  Function changePerspective;
  PerspectivePreview(this.title, this.changePerspective);

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          changePerspective(title);

          Navigator.pop(context);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title, ), Icon(Icons.edit, size: 12)]),
      ),
    );
  }
}
