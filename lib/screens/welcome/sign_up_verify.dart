import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpVerify extends StatefulWidget {
  const SignUpVerify({Key key, this.handleSignUp}) : super(key: key);

  final Function handleSignUp;

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

  returnDetails() {
    return int.parse(verificationController.value.text);
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
                'Final step :)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .17),
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: verificationController,
                maxLength: 6,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
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
            const SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                widget.handleSignUp();
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(.12),
                          offset: const Offset(0.0, 6.0),
                          blurRadius: 9),
                    ]),
                child: const Text(
                  'LET\'S GO!',
                  style: TextStyle(
                      letterSpacing: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
