import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class SphereOpenActionItems {
  void buildSphereOpenActionItems(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * .1,
                        decoration: BoxDecoration(
                            color: const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.block,
                          size: 17,
                          color: const Color(0xff555555),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Leave Sphere',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {},
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.block,
                          size: 17,
                          color: const Color(0xff555555),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Report Sphere',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  color: const Color(0xffeeeeee),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
