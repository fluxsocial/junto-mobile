import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';

class FilterChannelFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return FilterChannelModal();
            });
      },
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: <double>[0.1, 0.9],
              colors: <Color>[
                JuntoPalette.juntoSecondary,
                JuntoPalette.juntoPrimary,
              ],
            ),
            color: JuntoPalette.juntoWhite.withOpacity(.9),
            border: Border.all(
              color: JuntoPalette.juntoWhite,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Icon(CustomIcons.hash, size: 17, color: Colors.white)),
    );
  }
}

class FilterChannelModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterChannelModalState();
  }
}

class FilterChannelModalState extends State<FilterChannelModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff737373),
      child: Container(
        height: MediaQuery.of(context).size.height * .8,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 20,
                    color: const Color(0xff999999),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0.0, 2),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          hintText: 'filter by channel',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: const Color(0xff333333),
                        cursorWidth: 1,
                        maxLines: null,
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView(
              children: <Widget>[
                ChannelPreview(channel: 'design'),
                ChannelPreview(channel: 'philosophy'),
                ChannelPreview(channel: 'zen'),
                ChannelPreview(channel: 'plant based'),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
