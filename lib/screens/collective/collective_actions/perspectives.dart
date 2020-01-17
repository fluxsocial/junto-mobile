import 'package:flutter/material.dart';

class JuntoPerspectives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoPerspectivesState();
  }
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Perspectives',
                      style: Theme.of(context).textTheme.display1),
                  Icon(Icons.add)
                ],
              ),
            ),
            Container(
              height: 50,
              color: Theme.of(context).backgroundColor,
              child: Row(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xff555555),
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.yellow),
                  Container(height: 75, color: Colors.teal),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.green),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.yellow),
                  Container(height: 75, color: Colors.teal),
                  Container(height: 75, color: Colors.purple),
                  Container(height: 75, color: Colors.green),
                ],
              ),
            ),
          ]),
    );
  }
}
