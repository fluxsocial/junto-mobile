import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:provider/provider.dart';
import 'create_perspective/create_perspective.dart';

class Perspectives extends StatelessWidget {
  const Perspectives(
      {Key key, @required this.changePerspective, @required this.profile})
      : super(key: key);

  final ValueChanged<String> changePerspective;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Perspectives',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Color(0xff333333),
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
                        child: const Text(
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
                  padding: const EdgeInsets.all(0.0),
                  children: <Widget>[
                    PerspectiveTile(
                      name: 'JUNTO',
                      onClick: changePerspective,
                    ),
                    PerspectiveTile(
                      name: 'Degrees of separation',
                      onClick: changePerspective,
                    ),
                    PerspectiveTile(
                      name: 'Following',
                      onClick: changePerspective,
                    ),
                    _buildUserPerspectives(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserPerspectives(BuildContext context) {
    return FutureBuilder<List<CentralizedPerspective>>(
      future: Provider.of<UserProvider>(context)
          .getUserPerspective(profile.address),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CentralizedPerspective>> snapshot,
      ) {
        // if (!snapshot.hasData) {
        //   return Container(
        //     child: Center(
        //       child: const CircularProgressIndicator(),
        //     ),
        //   );
        // }
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          return ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: snapshot.data
                .map(
                  (CentralizedPerspective perspective) => PerspectiveTile(
                    name: perspective.name,
                    onClick: changePerspective,
                  ),
                )
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}

class PerspectiveTile extends StatelessWidget {
  const PerspectiveTile({
    Key key,
    this.onClick,
    this.name,
  }) : super(key: key);

  final ValueChanged<String> onClick;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        onTap: () {
          onClick(name);
          Navigator.pop(context);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: const TextStyle(
                color: Color(0xff333333),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
