import 'package:flutter/material.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({
    Key key,
    @required this.onNamePressed,
  }) : super(key: key);

  /// Called when the user enters a value in the textfield.
  /// Value will always be the latest value of `TextController.text.value`.
  final ValueChanged<String> onNamePressed;
  @override
  State<StatefulWidget> createState() {
    return SignUpNameState();
  }
}

class SignUpNameState extends State<SignUpName> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    nameController.addListener(returnDetails);
  }

  @override
  void dispose() {
    nameController.removeListener(returnDetails);
    nameController.dispose();
    super.dispose();
  }

  void returnDetails() => widget.onNamePressed(nameController.value.text);

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
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .24,
              ),
              child: const Text(
                'Hey, what\'s your name?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: nameController,
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.green),
                        hintText: 'My name is...',
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'FULL NAME',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      //FIXME:This does not rebuild with the correct value.
                      Text(
                        nameController.value.text.length.toString() + '/36',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
