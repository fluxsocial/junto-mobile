import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class CreateBullet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateBulletState();
  }
}

class CreateBulletState extends State<CreateBullet> {
  final List<Map<String, dynamic>> _bullets = <Map<String, dynamic>>[];
  int id = 1;

  // Function to add Bullet
  void _addBullet(Map<String, dynamic> bullet) {
    setState(() {
      id += 1;
      _bullets.add(bullet);
    });
  }

  // Function to remove bullet
  void _removeBullet() {
    setState(() {
      id -= 1;
      _bullets.removeLast();
    });
  }

  // Return the widget that calls _removeBullet()
  Widget _removeBulletWidget() {
    return GestureDetector(
      onTap: () {
        _removeBullet();
      },
      child: Icon(Icons.remove_circle_outline),
    );
  }

  // Initiate the first bullet
  @override
  void initState() {
    final Map<String, dynamic> bullet = <String, dynamic>{'key': id};

    _addBullet(bullet);
    super.initState();
  }

//ignore: unused_field
  final Map<String, dynamic> _bulletExpression = <String, dynamic>{
    'expression': <String, dynamic>{
      'expression_type': 'bulletform',
      'expression_data': <String, dynamic>{
        'BulletForm': <String, dynamic>{
          'title': 'optional title',
          'bullets': <String>['']
        }
      }
    },
    'tags': <String>[],
    'context': <String>['collective']
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: TextField(
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title (optional)',
                          ),
                          cursorColor: JuntoPalette.juntoGrey,
                          cursorWidth: 2,
                          maxLines: 1,
                          maxLength: 80,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final Map<String, dynamic> bullet = <String, dynamic>{
                            'key': id
                          };
                          _addBullet(bullet);
                          print(_bullets);
                        },
                        child: Icon(Icons.add_circle_outline),
                      )
                    ],
                  ),
                ),
                Container(
                    height: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: _bullets
                          .map(
                            (Map<String, dynamic> bullet) => Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color(0xffdddddd),
                                  width: 1,
                                ),
                              ),
                              height: 200,
                              width: MediaQuery.of(context).size.width - 20,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          bullet['key'].toString() +
                                              '/' +
                                              _bullets.length.toString(),
                                          style: const TextStyle(
                                            color: Color(
                                              0xff333333,
                                            ),
                                          ),
                                        ),
                                        bullet['key'] > 1
                                            ? _removeBulletWidget()
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    margin: const EdgeInsets.only(top: 20),
                                    child: TextField(
                                      buildCounter: (
                                        BuildContext context, {
                                        int currentLength,
                                        int maxLength,
                                        bool isFocused,
                                      }) =>
                                          null,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      cursorColor: JuntoPalette.juntoGrey,
                                      cursorWidth: 2,
                                      maxLines: null,
                                      maxLength: 220,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
