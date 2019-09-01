import 'package:flutter/material.dart';

class PerspectiveMemberPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/junto-mobile__eric.png',
              height: 36.0,
              width: 36.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(
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
                  children: const <Widget>[
                    Text(
                      'Eric Yang',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Text('sunyata'),
                  ],
                ),
                Container(
                  height: 17,
                  width: 17,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffeeeeee), width: 1.5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
