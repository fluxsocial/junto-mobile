import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    @required String currentTheme,
    Key key,
  })  : _currentTheme = currentTheme,
        super(key: key);

  final String _currentTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _setBackground(MediaQuery.of(context).size),
      ),
    );
  }

  Widget _setBackground(Size size) {
    String imageAsset;
    print(_currentTheme);

    if (_currentTheme == 'aqueous' || _currentTheme == 'aqueous-night') {
      imageAsset = 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (_currentTheme == 'royal' || _currentTheme == 'royal-night') {
      imageAsset = 'assets/images/junto-mobile__themes--royal.png';
    } else if (_currentTheme == 'rainbow' || _currentTheme == 'rainbow-night') {
      imageAsset = 'assets/images/junto-mobile__themes--rainbow.png';
    } else {
      imageAsset = 'assets/images/junto-mobile__themes--rainbow.png';
    }

    return Image.asset(
      imageAsset,
      key: ValueKey<String>(imageAsset),
      fit: BoxFit.cover,
      height: size.height,
      width: size.width,
    );
  }
}
