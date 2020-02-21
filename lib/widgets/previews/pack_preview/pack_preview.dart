import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/group_model.dart';

// This class renders a pack preview (usually shown in a list of packs)
class PackPreview extends StatelessWidget {
  const PackPreview({Key key, @required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          group.address == ''
              ? Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Transform.translate(
                    offset: const Offset(-1.0, 0),
                    child: Icon(
                      CustomIcons.packs,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 15,
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    CustomIcons.packs,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 15,
                  ),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: .5, color: Theme.of(context).dividerColor),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(group.groupData.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle1),
                  Text('username',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
