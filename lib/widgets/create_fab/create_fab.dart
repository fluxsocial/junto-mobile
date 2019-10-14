import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

// This widget is a Floating Action Button
class CreateFAB extends StatelessWidget {
  const CreateFAB({
    Key key,
    @required this.sphereHandle,
    @required this.isVisible,
    this.address,
  }) : super(key: key);

  final String sphereHandle;
  final ValueNotifier<bool> isVisible;
  final String address;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isVisible,
        builder: (BuildContext context, bool value, _) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoCreate(
                        sphereHandle,
                        address: address,
                      );
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                  ),
                );
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: <double>[0.1, 0.9],
                    colors: <Color>[
                      JuntoPalette.juntoSecondary,
                      JuntoPalette.juntoPrimary,
                    ],
                  ),
                  color: Colors.white.withOpacity(.7),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CustomIcons.lotus,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          );
        });
  }
}
