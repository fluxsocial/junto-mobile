import 'package:flutter/material.dart';

class CollectivePreviewCreate extends StatelessWidget {
  const CollectivePreviewCreate({
    @required this.group,
    @required this.selectedGroup,
  });
  final dynamic group;
  final dynamic selectedGroup;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/junto-mobile__app-icon.png',
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('c/junto',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(
                        'Junto Collective',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                  Radio(
                    value: group,
                    groupValue: selectedGroup,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
