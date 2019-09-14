import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/providers/collective_provider/collective_provider.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:provider/provider.dart';


class CreateActionsAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                CustomIcons.back_arrow_left,
                color: JuntoPalette.juntoSleek,
                size: 24,
              ),
            ),
            GestureDetector(
              onTap: () async {
                // For now we are using test data until the rich text editor
                // is up and running.
                await Provider.of<CollectiveProvider>(context)
                    .createExpression(null);
                Navigator.of(context).pop();
              },
              child: const Text(
                'create',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff333333),
                ),
              ),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffeeeeee),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
