import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/components/emoji_selector/emoji_selector.dart';
import 'package:junto_beta_mobile/models/emoji_model.dart';

class ExpressionOpenInteractions extends StatelessWidget {
  final ValueNotifier<String> responses = ValueNotifier<String>('Respond');

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _buildRespondModal(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .5 - 10,
                alignment: Alignment.center,
                child: ValueListenableBuilder<String>(
                  valueListenable: responses,
                  builder: (BuildContext context, String value, _) {
                    return Text(responses.value);
                  },
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width * .5 - 10,
                alignment: Alignment.center,
                child: const Text('Resonate'),
              ),
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
