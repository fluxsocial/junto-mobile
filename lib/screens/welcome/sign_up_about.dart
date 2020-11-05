import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field_counter.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignUpAbout extends StatefulWidget {
  final TextEditingController pronounController;
  final TextEditingController locationController;
  final TextEditingController websiteController;
  final FocusNode locationFocusNode;
  final FocusNode pronounFocusNode;
  final FocusNode websiteFocusNode;
  final Function nextPage;

  const SignUpAbout({
    Key key,
    this.nextPage,
    this.pronounController,
    this.locationController,
    this.websiteController,
    this.locationFocusNode,
    this.pronounFocusNode,
    this.websiteFocusNode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpAboutState();
  }
}

class SignUpAboutState extends State<SignUpAbout> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool _lengthValidator(String text, int fieldNumber, [int charCount = 30]) {
    bool lengthOk = text.length <= charCount;
    if (lengthOk) {
      if (fieldNumber == 1) {
        widget.pronounFocusNode.requestFocus();
      } else {
        widget.websiteFocusNode.requestFocus();
      }
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
                      valueController: widget.locationController,
                      onSubmit: () =>
                          _lengthValidator(widget.locationController.text, 1),
                      textInputActionType: TextInputAction.next,
                      hint: S.of(context).welcome_location_hint,
                      maxLength: 30,
                      textCapitalization: TextCapitalization.words,
                      focusNode: widget.locationFocusNode,
                    ),
                    SignUpTextFieldLabelAndCounter(
                      label: S.of(context).welcome_location_label,
                      maxLength: 30,
                      valueController: widget.locationController,
                      compact: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .08),
                    SignUpTextField(
                      valueController: widget.pronounController,
                      onSubmit: () =>
                          _lengthValidator(widget.pronounController.text, 2),
                      textInputActionType: TextInputAction.next,
                      hint: S.of(context).welcome_gender_hints,
                      maxLength: 30,
                      focusNode: widget.pronounFocusNode,
                    ),
                    SignUpTextFieldLabelAndCounter(
                      label: S.of(context).welcome_gender_label,
                      maxLength: 30,
                      valueController: widget.pronounController,
                      compact: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .08),
                    SignUpTextField(
                      valueController: widget.websiteController,
                      textInputActionType: TextInputAction.done,
                      focusNode: widget.websiteFocusNode,
                      onSubmit: () {
                        if (_lengthValidator(
                            widget.websiteController.text, 0, 100)) {
                          FocusScope.of(context).unfocus();
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
                      valueController: widget.websiteController,
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
