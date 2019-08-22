import 'package:flutter/material.dart';

class SearchMemberPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // nav to member profile
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      'assets/images/junto-mobile__eric.png',
                      height: 45.0,
                      width: 45.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 65,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: .5,
                          color: const Color(
                            0xffeeeeee,
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Eric Yang',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'sunyata',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
