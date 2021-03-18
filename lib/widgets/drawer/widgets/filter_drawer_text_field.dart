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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: .5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              color: Theme.of(context).primaryColorLight,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              autofocus: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
                counter: Container(),
              ),
              cursorColor: Theme.of(context).primaryColor,
              cursorWidth: 1,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          )
        ],
      ),
    );
  }
}
