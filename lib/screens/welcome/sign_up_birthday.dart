import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/sign_up_birthday_divider.dart';
import 'widgets/sign_up_birthday_text_field.dart';
import 'widgets/sign_up_text_field_counter.dart';

class SignUpBirthday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, child) {
        return Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(top: size.height * .16),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.24),
                Column(
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        child: SignUpBirthdayTextField(
                          hintText: 'Month',
                          maxLength: 2,
                        ),
                      ),
                      SignUpBirthdayDivider(),
                      Expanded(
                        child: SignUpBirthdayTextField(
                          maxLength: 2,
                          hintText: 'Day',
                        ),
                      ),
                      SignUpBirthdayDivider(),
                      Expanded(
                        child: SignUpBirthdayTextField(
                          maxLength: 4,
                          hintText: 'Year',
                        ),
                      ),
                    ]),
                    SignUpTextFieldLabelAndCounter(
                      label: 'BIRTHDAY',
                      // maxLength: widget.maxLength,
                      // valueController: widget.controller,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
