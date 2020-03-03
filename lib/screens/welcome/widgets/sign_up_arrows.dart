import 'package:flutter/material.dart';

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
                  color: Colors.white30,
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
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
