import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class ExpressionOpenContext extends StatelessWidget {
  const ExpressionOpenContext({this.channels, this.toggleExpressionContext});

  final List<dynamic> channels;
  final Function toggleExpressionContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff222222).withOpacity(.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(),
          Container(
            height: MediaQuery.of(context).size.width - 40,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(CustomIcons.create,
                    size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text('CHANNELS',
                          style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 1,
                    child: TabBarView(
                      children: <Widget>[
                        ListView(
                          padding: const EdgeInsets.all(0),
                          children: channels
                              .map(
                                (dynamic channel) =>
                                    ExpressionContextChannelPreview(channel),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: toggleExpressionContext,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox()
        ],
      ),
    );
  }
}

class ExpressionContextChannelPreview extends StatelessWidget {
  const ExpressionContextChannelPreview(this.channel);

  final String channel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(width: .5, color: Theme.of(context).dividerColor),
        ),
      ),
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
            margin: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(channel,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          )
        ],
      ),
    );
  }
}
