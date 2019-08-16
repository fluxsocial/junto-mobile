import 'package:flutter/material.dart';

class PerspectivePreview extends StatelessWidget {
  PerspectivePreview(this.title, this.changePerspective);
  
  final String title;
  final Function changePerspective;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          changePerspective(title);
          Navigator.pop(context);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500),
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
