import 'package:flutter/material.dart';

import 'create_perspective/create_perspective.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class Perspectives extends StatelessWidget {
  const Perspectives({
    Key key,
    @required this.changePerspective,
  }) : super(key: key);

  final ValueChanged<String> changePerspective;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                  JuntoPalette.juntoSecondary,
                  JuntoPalette.juntoPrimary
                ])),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Container(
                  // decoration: const BoxDecoration(
                  //   border: Border(
                  //     bottom: BorderSide(
                  //       color: Color(0xffeeeeee),
                  //       width: 1,
                  //     ),
                  //   ),
                  // ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Perspectives',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(
                            0xffffffff,
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
                        child: Container(
                          width: 20,
                          height: 38,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '+',
                            style: TextStyle(fontSize: 20),
                          ),
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
                            changePerspective('JUNTO');

                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('JUNTO',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            changePerspective('degrees of separation');
                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Degrees of separation',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            changePerspective('Following');
                            Navigator.pop(context);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text('Following',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
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
