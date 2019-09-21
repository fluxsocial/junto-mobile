import 'package:flutter/material.dart';

class DenCollectionPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xffeeeeee),
            width: .75,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'assets/images/junto-mobile__collection.png',
                height: 20,
                color: Color(0xff555555),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Anbu',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text('7 expressions')
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
