import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class SignUpArrows extends StatelessWidget {
  const SignUpArrows({
    Key key,
    @required PageController welcomeController,
    @required int currentIndex,
    @required VoidCallback onTap,
  })  : _welcomeController = welcomeController,
        _currentIndex = currentIndex,
        _onTap = onTap,
        super(key: key);

  final PageController _welcomeController;
  final int _currentIndex;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Positioned(
        bottom: MediaQuery.of(context).size.height * .05,
        right: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  _welcomeController.previousPage(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 400),
                  );
                },
                child: Container(
                  height: 36,
                  width: 36,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: theme.themeName.contains('sand')
                        ? Color(0xff555555).withOpacity(.3)
                        : Colors.white30,
                    size: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_currentIndex != 7)
              GestureDetector(
                onTap: _onTap,
                child: Container(
                  height: 36,
                  width: 36,
                  color: Colors.transparent,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.themeName.contains('sand')
                        ? Color(0xff555555)
                        : Colors.white,
                    size: 36,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
