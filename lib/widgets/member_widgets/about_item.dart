import 'package:flutter/material.dart';

class AboutItem extends StatelessWidget {
  const AboutItem({this.item, this.icon});
  final List<String> item;
  final dynamic icon;
  @override
  Widget build(BuildContext context) {
    return item.isNotEmpty && item[0].isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                icon,
                const SizedBox(width: 5),
                Text(
                  item[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
