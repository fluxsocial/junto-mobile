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
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                '1. Be aware of the impact your words and actions have. Embrace kindness and compassion when interacting with others.',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              child: Text(
                '2. Accept everyone else\'s experience as valid, even if it doesn\'t look like yours',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              child: Text(
                '3. Expresson yourself freely. Be real and hold space for authenticity.',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
