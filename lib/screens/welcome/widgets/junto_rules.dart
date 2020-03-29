import 'package:flutter/material.dart';

class JuntoRules extends StatelessWidget {
  const JuntoRules({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .1),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .05,
              ),
              child: Text(
                'I. Express yourself freely. Be real and hold space for authenticity.',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .05,
              ),
              child: Text(
                "II. Accept everyone else's experience as valid, even if it doesn't look like yours.",
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              child: Text(
                'III. Be aware of the impact your words and actions have. Embrace kindness and compassion when interacting with others.',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
