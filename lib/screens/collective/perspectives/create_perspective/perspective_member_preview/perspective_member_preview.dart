import 'package:flutter/material.dart';

class PerspectiveMemberPreview extends StatelessWidget {
  const PerspectiveMemberPreview({
    Key key,
    @required this.name,
    @required this.username,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
    this.showIndicator = false,
    this.indicatorColor = Colors.white,
  }) : super(key: key);

  final String name;
  final String username;
  final EdgeInsets padding;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: padding,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/junto-mobile__logo.png',
              height: 36.0,
              width: 36.0,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width - 66,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .5,
                    color: Color(
                      0xffeeeeee,
                    ),
                  ),
                ),
              ),
              margin: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(username),
                    ],
                  ),
                  if (showIndicator)
                    Container(
                      height: 17,
                      width: 17,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        border: Border.all(
                            color: const Color(0xffeeeeee), width: 1.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
