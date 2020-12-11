import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/cta_button.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar({
    Key key,
    @required this.onNext,
    @required this.expressionHasData,
  }) : super(key: key);

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(.75),
          child: Container(
            height: .75,
            color: Theme.of(context).dividerColor,
            width: MediaQuery.of(context).size.width,
          ),
        ),
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
                        size: 17,
                        color: Theme.of(context).primaryColor,
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
