
import 'package:flutter/material.dart';

class FeedPlaceholder extends StatelessWidget {
  const FeedPlaceholder({this.placeholderText});

  final String placeholderText;
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -50),
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * .1 + 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/junto-mobile__placeholder--feed.png',
              height: MediaQuery.of(context).size.height * .1,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Text(
                placeholderText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
