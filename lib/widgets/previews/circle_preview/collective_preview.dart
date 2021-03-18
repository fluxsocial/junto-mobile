import 'package:flutter/material.dart';

class CollectivePreview extends StatelessWidget {
  const CollectivePreview({this.callback});

  final Function callback;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
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
                child: Column(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
