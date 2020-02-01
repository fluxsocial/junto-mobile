import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';

class ChannelPreview extends StatelessWidget {
  const ChannelPreview({Key key, this.channel}) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.2, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  CustomIcons.hash,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 95,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
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
                    Text(channel.name,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text('x expressions',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
