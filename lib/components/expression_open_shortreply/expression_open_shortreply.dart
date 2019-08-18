import 'package:flutter/material.dart';

class ExpressionOpenShortReply extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 250,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffeeeeee),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          style: const TextStyle(fontSize: 17),
          maxLines: null,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Reply to Eric',
          ),
        ),
      ),
    );
  }
}
