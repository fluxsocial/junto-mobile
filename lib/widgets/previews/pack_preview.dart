import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';

// This class renders a pack preview (usually shown in a list of packs)
class PackPreview extends StatelessWidget {
  const PackPreview({Key key, @required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => PackOpen(
              pack: group,
            ),
          ),
        );
      },
      child: Container(
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
                        size: 17,
                      ),
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                      group.address,
                      height: 45.0,
                      width: 45.0,
                      fit: BoxFit.cover,
                    ),
                  ),
            Container(
              width: MediaQuery.of(context).size.width - 75,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: .5, color: Theme.of(context).dividerColor),
                ),
              ),
              margin: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(group.groupData.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subhead),
                  Text(group.creator,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.body1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
