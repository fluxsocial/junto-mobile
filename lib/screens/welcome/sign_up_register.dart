import 'package:flutter/material.dart';

class SignUpRegister extends StatefulWidget {
  const SignUpRegister({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpRegisterState();
  }
}

class SignUpRegisterState extends State<SignUpRegister> {
  TextEditingController bioController;
  TextEditingController locationController;
  TextEditingController genderController;
  TextEditingController websiteController;

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController();
    locationController = TextEditingController();
    genderController = TextEditingController();
    websiteController = TextEditingController();
  }

  Map<String, dynamic> returnDetails() {
    return <String, dynamic>{
      'bio': bioController.value.text,
      'location': locationController.value.text,
      'gender': genderController.value.text,
      'website': websiteController.value.text
    };
  }

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
            Container(
              child: const Text(
                'Almost done!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: bioController,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            cursorColor: Colors.white70,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: locationController,
                            cursorColor: Colors.white70,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: genderController,
                            cursorColor: Colors.white70,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Confirm password',
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
