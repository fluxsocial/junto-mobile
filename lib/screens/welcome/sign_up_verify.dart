import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:provider/provider.dart';

class SignUpVerify extends StatefulWidget {
  const SignUpVerify({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpVerifyState();
  }
}

class SignUpVerifyState extends State<SignUpVerify> {
  TextEditingController verificationController;

  @override
  void initState() {
    super.initState();
    verificationController = TextEditingController();
  }

  Map<String, dynamic> returnDetails() {
    return <String, dynamic>{
      'verification_code': verificationController.value.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text(
                  'Final step :)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .17),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: verificationController,
                            maxLength: 6,
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            cursorColor: Colors.white70,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Six digit verification code',
                              hintStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'CHECK EMAIL',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// RaisedButton(onPressed: () async {
//   final response =
//       await Provider.of<AuthRepo>(context).registerUser(
//     UserAuthRegistrationDetails(
//         bio: 'ay',
//         name: 'Junto',
//         email: 'hi@junto.foundation',
//         username: 'junto.foundation',
//         website: [],
//         location: [],
//         gender: [],
//         profileImage: [],
//         password: 'hellos',
//         verificationCode: 610869),
//   );
//   print(response);
// })
