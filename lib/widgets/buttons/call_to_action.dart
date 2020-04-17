import 'package:flutter/material.dart';

class CallToActionButton extends StatelessWidget {
  const CallToActionButton({
    Key key,
    @required this.callToAction,
    @required this.title,
  }) : super(key: key);

  final VoidCallback callToAction;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xff222222).withOpacity(.2),
            offset: const Offset(0.0, 5.0),
            blurRadius: 9,
          ),
        ],
      ),
      child: FlatButton(
        color: Theme.of(context).accentColor,
        onPressed: callToAction,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 30.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              letterSpacing: 1.7,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
