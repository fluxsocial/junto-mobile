import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field_counter.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignUpAbout extends StatefulWidget {
  const SignUpAbout({Key key, this.nextPage}) : super(key: key);

  final Function nextPage;

  @override
  State<StatefulWidget> createState() {
    return SignUpAboutState();
  }
}

class SignUpAboutState extends State<SignUpAbout> {
  TextEditingController bioController;
  TextEditingController locationController;
  TextEditingController genderController;
  TextEditingController websiteController;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    bioController = TextEditingController();
    locationController = TextEditingController();
    genderController = TextEditingController();
    websiteController = TextEditingController();
  }

  @override
  void dispose() {
    bioController.dispose();
    locationController.dispose();
    genderController.dispose();
    websiteController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  AboutPageModel returnDetails() => AboutPageModel(
        bio: bioController.value.text,
        location: locationController.value.text,
        gender: genderController.value.text,
        website: websiteController.value.text,
      );

  bool _lengthValidator(String text, [int charCount = 30]) {
    bool lengthOk = text.length <= charCount;
    if (lengthOk) {
      FocusScope.of(context).nextFocus();
      return true;
    } else {
      FocusScope.of(context).unfocus();
      showFeedback(context,
          message: 'Length must be less than ${charCount} characters');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: KeyboardAvoider(
                autoScroll: true,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * .24),
                    SignUpTextField(
                      valueController: locationController,
                      onSubmit: () =>
                          _lengthValidator(locationController.value.text),
                      textInputActionType: TextInputAction.next,
                      hint: S.of(context).welcome_location_hint,
                      maxLength: 30,
                      textCapitalization: TextCapitalization.words,
                    ),
                    SignUpTextFieldLabelAndCounter(
                      label: S.of(context).welcome_location_label,
                      maxLength: 30,
                      valueController: locationController,
                      compact: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .08),
                    SignUpTextField(
                      valueController: genderController,
                      onSubmit: () =>
                          _lengthValidator(genderController.value.text),
                      textInputActionType: TextInputAction.next,
                      hint: S.of(context).welcome_gender_hints,
                      maxLength: 30,
                    ),
                    SignUpTextFieldLabelAndCounter(
                      label: S.of(context).welcome_gender_label,
                      maxLength: 30,
                      valueController: locationController,
                      compact: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .08),
                    SignUpTextField(
                      valueController: websiteController,
                      textInputActionType: TextInputAction.done,
                      onSubmit: () {
                        if (_lengthValidator(
                            websiteController.value.text, 100)) {
                          widget.nextPage();
                        }
                      },
                      hint: S.of(context).welcome_website_hint,
                      maxLength: 100,
                      keyboardType: TextInputType.url,
                      textCapitalization: TextCapitalization.none,
                    ),
                    SignUpTextFieldLabelAndCounter(
                      label: S.of(context).welcome_website_label,
                      maxLength: 100,
                      valueController: locationController,
                      compact: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
