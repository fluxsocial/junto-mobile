import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/junto_logo.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/junto_name.dart';
import 'package:provider/provider.dart';

class UnsupportedVersion extends StatelessWidget {
  const UnsupportedVersion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            JuntoLogo(),
            JuntoName(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
              child: Text(
                "Your copy of Junto must be updated. You can do so by visiting your device's app store",
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    onPressed: () async {},
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    color: Colors.transparent,
                    child: Text(
                      "Update".toUpperCase(),
                      style: TextStyle(
                        color: JuntoPalette().juntoWhite(
                            theme: Provider.of<JuntoThemesProvider>(context)),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
