import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/junto_name.dart';
import 'package:junto_beta_mobile/widgets/logos/junto_logo_outline.dart';
import 'package:provider/provider.dart';
import 'package:store_launcher/store_launcher.dart';

class UpdateApp extends StatelessWidget {
  const UpdateApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            JuntoLogoOutline(),
            JuntoName(),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 40.0,
              ),
              child: Text(
                "Your copy of Junto must be updated. You can do so by visiting your device's app store.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Spacer(),
           ],
        ),
      ),
    );
  }
}
