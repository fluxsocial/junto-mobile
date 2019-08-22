import 'package:flutter/material.dart';

import 'create_perspective/create_perspective.dart';

class Perspectives extends StatelessWidget {
  const Perspectives(this._changePerspective);

  final ValueChanged<String> _changePerspective;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffeeeeee),
                        width: 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'PERSPECTIVES',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(
                            0xff333333,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  CreatePerspective(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                  height: 45,
                  margin: EdgeInsets.only(top: statusBarHeight),
                ),
                Expanded(
                    child: ListView(
                        padding: const EdgeInsets.all(
                          0,
                        ),
                        children: <Widget>[
                      Container(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            _changePerspective('JUNTO');

                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('JUNTO'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            _changePerspective('degrees of separation');
                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Degrees of Separation'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            _changePerspective('Following');
                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Following'),
                            ],
                          ),
                        ),
                      ),
                      // ListView(
                      //     padding: EdgeInsets.all(0),
                      //     shrinkWrap: true,
                      //     physics: ClampingScrollPhysics(),
                      //     children: model.perspectives
                      //         .map((perspective) => PerspectivePreview(
                      //             perspective.perspectiveTitle,
                      //             _changePerspective,))
                      //         .toList(),
                      //   ),
                    ]))
              ],
            )),
      ),
    );
  }
}
