import 'package:flutter/material.dart';

import 'create_perspective/create_perspective.dart';

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
                    PerspectiveTile(
                      name: 'JUNTO',
                      changePerspective: changePerspective,
                    ),
                    PerspectiveTile(
                      name: 'degrees of separation',
                      changePerspective: changePerspective,
                    ),
                    PerspectiveTile(
                      name: 'Following',
                      changePerspective: changePerspective,
                    ),

                    //TODO(Nash): Get list of user perspectives then display.
                    // Ref: github.com/juntofoundation/Junto-Holochain-Alpha-API/issues/8
                    PerspectiveTile(
                      name: 'Testing',
                      changePerspective: changePerspective,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Tile which displays the name of the [Perspective]. Contains a callback
/// which changes the perspective.
class PerspectiveTile extends StatelessWidget {
  const PerspectiveTile({
    Key key,
    @required this.name,
    @required this.changePerspective,
  }) : super(key: key);

  /// Name of the Perspective.
  final String name;

  /// Callback called with the name of the perspective.
  final ValueChanged<String> changePerspective;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          changePerspective(name);
          Navigator.pop(context);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(name),
          ],
        ),
      ),
    );
  }
}
