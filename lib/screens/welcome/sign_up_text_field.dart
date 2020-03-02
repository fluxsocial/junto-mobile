import 'package:flutter/material.dart';

class SignUpTextField extends StatefulWidget {
  const SignUpTextField({
    Key key,
    @required this.onValueChanged,
    @required this.onSubmit,
    @required this.maxLength,
    @required this.hint,
    @required this.label,
    @required this.title,
  }) : super(key: key);

  /// Called when the user enters a value in the textfield.
  /// Value will always be the latest value of `TextController.text.value`.
  final ValueChanged<String> onValueChanged;
  final VoidCallback onSubmit;
  final int maxLength;
  final String hint;
  final String label;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return SignUpTextFieldState();
  }
}

class SignUpTextFieldState extends State<SignUpTextField> {
  TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    valueController = TextEditingController();
    valueController.addListener(returnDetails);
  }

  @override
  void dispose() {
    valueController.removeListener(returnDetails);
    valueController.dispose();
    super.dispose();
  }

  void returnDetails() => widget.onValueChanged(valueController.value.text);

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
              child: Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: valueController,
                    cursorColor: Colors.white70,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.green),
                      hintText: widget.hint,
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: Colors.white,
                      //disabling the native counter
                      counter: Container(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLength: widget.maxLength,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      widget.onSubmit();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: valueController,
                        builder: (
                          BuildContext context,
                          TextEditingValue value,
                          _,
                        ) {
                          return Text(
                            '${value.text.length}/${widget.maxLength}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
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
