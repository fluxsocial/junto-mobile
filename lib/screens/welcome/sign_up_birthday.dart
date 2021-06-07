import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/theme/themes_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/sign_up_birthday_divider.dart';
import 'widgets/sign_up_birthday_text_field.dart';
import 'widgets/sign_up_text_field_counter.dart';

class SignUpBirthday extends StatelessWidget {
  const SignUpBirthday({
    this.monthController,
    this.dayController,
    this.yearController,
  });

  final TextEditingController monthController;
  final TextEditingController dayController;
  final TextEditingController yearController;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, child) {
        return Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * .17),
                SignUpBirthdayTitle(),
                SizedBox(height: MediaQuery.of(context).size.height * .2),
                Column(
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        child: SignUpBirthdayTextField(
                          hintText: 'Month',
                          maxLength: 2,
                          textController: monthController,
                        ),
                      ),
                      SignUpBirthdayDivider(),
                      Expanded(
                        child: SignUpBirthdayTextField(
                          maxLength: 2,
                          hintText: 'Day',
                          textController: dayController,
                        ),
                      ),
                      SignUpBirthdayDivider(),
                      Expanded(
                        child: SignUpBirthdayTextField(
                          maxLength: 4,
                          hintText: 'Year',
                          textController: yearController,
                        ),
                      ),
                    ]),
                    SignUpTextFieldLabelAndCounter(label: 'BIRTHDAY')
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

class SignUpBirthdayTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Please enter your birthday. You must be 13 years or older to sign up.',
      style: TextStyle(
        color: Colors.white.withOpacity(.70),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
