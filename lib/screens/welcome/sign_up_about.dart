import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_page_title.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field_counter.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignUpAbout extends StatefulWidget {
  const SignUpAbout({Key key}) : super(key: key);

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
        bio: bioController.value.text == '' ? ' ' : bioController.value.text,
        location: locationController.value.text,
        gender: genderController.value.text,
        website: websiteController.value.text,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SignUpPageTitle(
              title: 'Feel free to share more about yourself (optional)',
            ),
            Flexible(
              child: KeyboardAvoider(
                autoScroll: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 50),
                      SignUpTextField(
                        valueController: locationController,
                        onSubmit: () {
                          FocusScope.of(context).nextFocus();
                        },
                        hint: 'Location',
                        maxLength: 100,
                      ),
                      SignUpTextFieldLabelAndCounter(
                        label: 'LOCATION',
                        maxLength: 100,
                        valueController: locationController,
                        compact: true,
                      ),
                      const SizedBox(height: 40),
                      SignUpTextField(
                        valueController: genderController,
                        onSubmit: () {
                          FocusScope.of(context).nextFocus();
                        },
                        hint: 'Gender Pronouns',
                        maxLength: 50,
                      ),
                      SignUpTextFieldLabelAndCounter(
                        label: 'PRONOUNS',
                        maxLength: null,
                        valueController: locationController,
                        compact: true,
                      ),
                      const SizedBox(height: 30),
                      SignUpTextField(
                        valueController: websiteController,
                        onSubmit: () {
                          FocusScope.of(context).unfocus();
                        },
                        hint: 'Website',
                        maxLength: 50,
                        keyboardType: TextInputType.url,
                        textCapitalization: TextCapitalization.none,
                      ),
                      SignUpTextFieldLabelAndCounter(
                        label: 'WEBSITE',
                        maxLength: null,
                        valueController: locationController,
                        compact: true,
                      ),
                    ],
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
