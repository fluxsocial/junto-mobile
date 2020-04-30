import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';
import 'audio_gradient_selector.dart';

class AudioBottomTools extends StatefulWidget {
  const AudioBottomTools({
    this.onPickPressed,
    this.resetAudioPhotoBackground,
    this.setAudioGradientValues,
  });

  final Function resetAudioPhotoBackground;
  final Function setAudioGradientValues;
  final Function onPickPressed;
  @override
  State<StatefulWidget> createState() {
    return AudioBottomToolsState();
  }
}

class AudioBottomToolsState extends State<AudioBottomTools> {
  bool gradientSelectorVisible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedCrossFade(
            crossFadeState: gradientSelectorVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(
              milliseconds: 200,
            ),
            firstChild: AudioBottomToolsDefault(
              resetAudioPhotoBackground: widget.resetAudioPhotoBackground,
              onPickPressed: widget.onPickPressed,
              toggleGradientSelector: _toggleGradientSelector,
            ),
            secondChild: AudioGradientSelector(
              toggleGradientSelector: _toggleGradientSelector,
              setAudioGradientValues: widget.setAudioGradientValues,
            ),
          )
        ],
      ),
    );
  }

  void _toggleGradientSelector() {
    setState(() {
      if (gradientSelectorVisible) {
        gradientSelectorVisible = false;
      } else {
        gradientSelectorVisible = true;
      }
    });
  }
}

class AudioBottomToolsDefault extends StatelessWidget {
  const AudioBottomToolsDefault({
    this.onPickPressed,
    this.resetAudioPhotoBackground,
    this.toggleGradientSelector,
  });

  final Function resetAudioPhotoBackground;
  final Function onPickPressed;
  final Function toggleGradientSelector;
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return Container(
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
            Expanded(
              child: InkWell(
                onTap: () async {
                  await audio.resetRecording();
                  resetAudioPhotoBackground();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Theme.of(context).primaryColorLight,
                    size: 28,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: toggleGradientSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.invert_colors,
                    color: Theme.of(context).primaryColorLight,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  onPickPressed();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColorLight,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
