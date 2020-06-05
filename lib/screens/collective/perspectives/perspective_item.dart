import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/about_perspective.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class PerspectiveItem extends StatelessWidget {
  const PerspectiveItem({
    Key key,
    @required this.perspective,
    @required this.onTap,
  }) : super(key: key);
  final PerspectiveModel perspective;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _buildPerspective(
      context,
      perspective,
      onTap,
    );
  }

  String _buildIcon(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__perspective--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__perspective--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__perspective--purpgold.png';
    } else if (theme == 'fire' || theme == 'fire-night') {
      return 'assets/images/junto-mobile__perspective--fire.png';
    } else if (theme == 'forest' || theme == 'forest-night') {
      return 'assets/images/junto-mobile__perspective--forest.png';
    } else if (theme == 'sand' || theme == 'sand-night') {
      return 'assets/images/junto-mobile__perspective--sand.png';
    } else if (theme == 'dark') {
      return 'assets/images/junto-mobile__perspective--dark.png';
    } else if (theme == 'dark-night') {
      return 'assets/images/junto-mobile__perspective--white.png';
    } else {
      return 'assets/images/junto-mobile__perspective--rainbow.png';
    }
  }

  Widget _buildPerspective(
      BuildContext context, PerspectiveModel perspective, VoidCallback onTap) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    _buildIcon(theme.themeName),
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    perspective.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    builder: (BuildContext context) => AboutPerspective(
                      incomingPerspective: perspective,
                    ),
                  );
                },
                child: Container(
                  width: 38,
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: Icon(
                    CustomIcons.morevertical,
                    size: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
