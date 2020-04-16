import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioBottomTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await audio.resetRecording();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: Theme.of(context).primaryColorLight,
                        size: 28,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await audio.resetRecording();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColorLight,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
