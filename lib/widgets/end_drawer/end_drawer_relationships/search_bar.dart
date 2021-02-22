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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          contentPadding: const EdgeInsets.all(0.0),
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorLight),
        ),
        cursorColor: Theme.of(context).primaryColor,
        cursorWidth: 1,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
        maxLength: 80,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
