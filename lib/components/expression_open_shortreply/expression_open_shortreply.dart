import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

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
            color: JuntoPalette.juntoFade,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 10, horizontal: JuntoStyles.horizontalPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: JuntoPalette.juntoFade,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding),
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
