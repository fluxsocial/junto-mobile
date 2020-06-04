import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';

class ChannelPreview extends StatelessWidget {
  const ChannelPreview({Key key, this.channel, this.resultCount})
      : super(key: key);

  final Channel channel;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 38.0,
            width: 38.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const <double>[0.2, 0.9],
                colors: <Color>[
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              CustomIcons.newhashtag,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
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
                  Text(
                    channel.name,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  // const SizedBox(height: 2.5),
                  // Text(
                  //   _expressionText(),
                  //   textAlign: TextAlign.start,
                  //   style: Theme.of(context).textTheme.subtitle1.copyWith(
                  //         color: Theme.of(context).primaryColorLight,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
