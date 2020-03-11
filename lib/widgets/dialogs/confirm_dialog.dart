import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({this.confirmationText, this.confirm, this.deny});
  final String confirmationText;
  final Function confirm;
  final Function deny;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              confirmationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => deny,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'NO',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => confirm,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'YES',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
