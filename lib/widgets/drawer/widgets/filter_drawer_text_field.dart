import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class FilterDrawerTextField extends StatelessWidget {
  const FilterDrawerTextField({
    Key key,
    @required this.textEditingController,
    @required this.focusNode,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff444444),
            width: .75,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
                counter: Container(),
                hintText: 'Filter by channel',
                hintStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff999999),
                ),
              ),
              cursorColor: Colors.white,
              cursorWidth: 1,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLength: 80,
              textInputAction: TextInputAction.done,
            ),
          ),
          GestureDetector(
            onTap: textEditingController.clear,
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                CustomIcons.cancel,
                size: 24,
                color: const Color(0xff999999),
              ),
            ),
          )
        ],
      ),
    );
  }
}
