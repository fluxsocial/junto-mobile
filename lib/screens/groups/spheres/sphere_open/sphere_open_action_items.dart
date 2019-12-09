import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class SphereOpenActionItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Leave Sphere',
                          style: Theme.of(context).textTheme.headline),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {},
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Report Sphere',
                          style: Theme.of(context).textTheme.headline),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
