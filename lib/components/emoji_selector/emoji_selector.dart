import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/emoji_model.dart';

class EmojiSelector extends StatelessWidget {
  const EmojiSelector({
    Key key,
    @required this.parsedEmoji,
    @required this.onEmojiSelected,
  }) : super(key: key);

  final List<Emoji> parsedEmoji;
  final ValueChanged<Emoji> onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(12.0),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 6.0,
        ),
        itemCount: parsedEmoji.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => onEmojiSelected(parsedEmoji[index]),
            child: Text(
              parsedEmoji[index].code,
              style: const TextStyle(
                fontSize: 26.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
