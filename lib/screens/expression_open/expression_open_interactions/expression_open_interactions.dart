import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/components/emoji_selector/emoji_selector.dart';
import 'package:junto_beta_mobile/models/emoji_model.dart';
import 'package:junto_beta_mobile/palette.dart';

class ExpressionOpenInteractions extends StatelessWidget {
  final ValueNotifier<String> responses = ValueNotifier<String>('Respond');

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
        )),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _buildRespondModal(context);
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * .5 - 10,
                alignment: Alignment.center,
                child: ValueListenableBuilder<String>(
                  valueListenable: responses,
                  builder: (BuildContext context, String value, _) {
                    return Text(
                      responses.value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    );
                  },
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * .5 - 10,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/junto-mobile__resonation.png',
                        height: 17,
                        color: JuntoPalette.juntoGrey,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Resonate',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  // Build bottom modal to add channels to expression
  Future<void> _buildRespondModal(BuildContext context) async {
    final List<Emoji> parsedEmoji = <Emoji>[];

    // Emoji sourced from https://github.com/omnidan/node-emoji/blob/master/lib/emoji.json
    final String emojiJson = await rootBundle.loadString('assets/emoji.json');
    final Map<String, dynamic> emoji = json.decode(emojiJson);
    emoji.forEach(
      (String key, dynamic value) {
        parsedEmoji.add(
          Emoji(key, value),
        );
      },
    );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EmojiSelector(
          parsedEmoji: parsedEmoji,
          onEmojiSelected: (Emoji emoji) {
            responses.value = emoji.code;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
