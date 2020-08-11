import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/cta_button.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar({
    Key key,
    @required this.expressionType,
    @required this.onNext,
    @required this.expressionHasData,
  }) : super(key: key);

  final ExpressionType expressionType;
  final VoidCallback onNext;
  final Function expressionHasData;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(45),
      child: AppBar(
        brightness: Theme.of(context).brightness,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (expressionHasData()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ConfirmDialog(
                        confirmationText:
                            'Are you sure you want to leave this screen? Your expression will not be saved.',
                        confirm: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        CustomIcons.back,
                        size: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        expressionType.appBarName().toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CreateCTAButton(cta: onNext, title: 'Next'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
