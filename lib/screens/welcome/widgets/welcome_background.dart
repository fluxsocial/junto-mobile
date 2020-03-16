import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    @required String currentTheme,
    Key key,
  })  : _currentTheme = currentTheme,
        super(key: key);

  final String _currentTheme;

  static const Map<String, String> backgroundMap = <String, String>{
    'aqueous': 'assets/images/junto-mobile__themes--aqueous.png',
    'aqueous-night': 'assets/images/junto-mobile__themes--aqueous.png',
    'royal': 'assets/images/junto-mobile__themes--royal.png',
    'royal-night': 'assets/images/junto-mobile__themes--royal.png',
    'rainbow': 'assets/images/junto-mobile__themes--rainbow.png',
    'rainbow-night': 'assets/images/junto-mobile__themes--rainbow.png',
    'default': 'assets/images/junto-mobile__themes--rainbow.png',
  };

  static const Widget defaultBackground = ImageBackground(
    'assets/images/junto-mobile__themes--aqueous.png',
    key: ValueKey<String>('aqueous'),
  );

  @override
  Widget build(BuildContext context) {
    String key = _currentTheme;
    if (!backgroundMap.containsKey(_currentTheme)) {
      key = 'default';
    }

    return Container(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              // this way there's always some widget in the background
              // and we don't go through white background
              defaultBackground,
              ...previousChildren,
              if (currentChild != null)
                currentChild,
            ],
            alignment: Alignment.center,
          );
        },
        child: ImageBackground(
          backgroundMap[key],
          key: ValueKey<String>(key),
        ),
      ),
    );
  }
}

class ImageBackground extends StatelessWidget {
  const ImageBackground(
    this.imageAsset, {
    Key key,
  }) : super(key: key);

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Image.asset(
      imageAsset,
      key: ValueKey<String>(imageAsset),
      fit: BoxFit.cover,
      height: size.height,
      width: size.width,
    );
  }
}
