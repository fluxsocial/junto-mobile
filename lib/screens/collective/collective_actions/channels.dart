import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class JuntoChannels extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoChannelsState();
  }
}

class JuntoChannelsState extends State<JuntoChannels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 80,
              color: Theme.of(context).backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(CustomIcons.packs, size: 17),
                  const SizedBox(width: 10),
                  Text(
                    'JUNTO',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              color: Theme.of(context).backgroundColor,
              // color: Colors.green,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0.0, 10.0),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0.0),
                          hintText: 'filter by channel',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 1,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //   height: 50,
            //   color: Theme.of(context).backgroundColor,
            //   child: Row(
            //     children: <Widget>[
            //       Icon(CustomIcons.packs, size: 17),
            //       SizedBox(width: 10),
            //       Text(
            //         'JUNTO',
            //         style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500,
            //             color: Theme.of(context).primaryColor),
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.yellow),
                  Container(height: 75, color: Colors.teal),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.green),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.yellow),
                  Container(height: 75, color: Colors.teal),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.green),
                ],
              ),
            ),
          ]),
    );
  }
}
