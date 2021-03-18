import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) onTextChange;
  final String hintText;

  const SearchBar({
    Key key,
    this.textEditingController,
    this.onTextChange,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // color: Theme.of(context).dividerColor,
        // borderRadius: BorderRadius.circular(25),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).primaryColorLight,
            size: 17,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 40,
              child: TextField(
                controller: textEditingController,
                onChanged: onTextChange,
                buildCounter: (
                  BuildContext context, {
                  int currentLength,
                  int maxLength,
                  bool isFocused,
                }) =>
                    null,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorLight),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 1,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
                maxLength: 80,
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
