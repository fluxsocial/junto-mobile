import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere_next/create_sphere_next.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:provider/provider.dart';

// This class renders a widget that enables the user to create a sphere
class CreateSphere extends StatefulWidget {
  @override
  _CreateSphereState createState() => _CreateSphereState();
}

class _CreateSphereState extends State<CreateSphere> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _createSphere() async {
    final UserProfile _profile =
        await Provider.of<UserProvider>(context).readLocalUser();
    final String sphereName = _textEditingController.value.text;
    final CentralizedSphere sphere = CentralizedSphere(
      name: sphereName,
      description: '',
      facilitators: [
        _profile.address,
      ],
      photo: '',
      members: <String>[],
      principles: "Don't be a horrible human being",
      sphereHandle: sphereName,
      privacy: '',
    );
    Navigator.of(context).push(CreateSphereNext.route(sphere));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: const IconThemeData(
              color: JuntoPalette.juntoSleek,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: JuntoStyles.horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CustomIcons.back_arrow_left,
                      color: JuntoPalette.juntoSleek,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: _createSphere,
                    child: const Text('next', style: JuntoStyles.body),
                  )
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: JuntoPalette.juntoFade,
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: JuntoStyles.horizontalPadding),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: JuntoPalette.juntoFade,
                    width: 1,
                  ),
                )),
                child: TextField(
                  controller: _textEditingController,
                  buildCounter: (
                    BuildContext context, {
                    int currentLength,
                    int maxLength,
                    bool isFocused,
                  }) =>
                      null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name your sphere',
                  ),
                  style: const TextStyle(fontSize: 17),
                  cursorColor: JuntoPalette.juntoSleek,
                  cursorWidth: 2,
                  maxLines: 1,
                  maxLength: 80,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: JuntoPalette.juntoFade, width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.search, size: 17),
                      const SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextField(
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add members to your sphere',
                          ),
                          cursorColor: JuntoPalette.juntoSleek,
                          style: const TextStyle(fontSize: 14),
                          cursorWidth: 2,
                          maxLines: 1,
                          maxLength: 80,
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: ListView(
                children: const <Widget>[],
              ))
            ],
          ),
        ));
  }
}
