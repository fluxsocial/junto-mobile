import 'package:flutter/material.dart';

class SignUpUsername extends StatefulWidget {
  const SignUpUsername({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SignUpUsernameState();
}

class SignUpUsernameState extends State<SignUpUsername> {
  TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  String returnDetails() {
    return usernameController.value.text;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .17,
              ),
              child: const Text(
                'Let\'s get a unique username for you!',
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
                      controller: usernameController,
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.green),
                        hintText: 'I\'ll go by...',
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
                        'USERNAME',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        usernameController.value.text.length.toString() + '/22',
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
