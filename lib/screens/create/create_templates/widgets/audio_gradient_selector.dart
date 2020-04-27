import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:provider/provider.dart';

class AudioGradientSelector extends StatelessWidget {
  const AudioGradientSelector({
    this.toggleGradientSelector,
    this.setAudioGradientValues,
    this.resetAudioGradientValues,
  });

  final Function toggleGradientSelector;
  final Function setAudioGradientValues;
  final Function resetAudioGradientValues;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return Column(children: <Widget>[
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
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          height: 68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AudioGradientSelectorItem(
                      '8E8098',
                      '307FAA',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '6F51A8',
                      'E8B974',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '2E4F78',
                      '6397C7',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '719cf4',
                      'ffc7e4',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '639acf',
                      '7bdaa5',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '8E8098',
                      '307FAA',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '6F51A8',
                      'E8B974',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '2E4F78',
                      '6397C7',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '719cf4',
                      'ffc7e4',
                      setAudioGradientValues,
                    ),
                    AudioGradientSelectorItem(
                      '639acf',
                      '7bdaa5',
                      setAudioGradientValues,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  resetAudioGradientValues();
                  toggleGradientSelector();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Icon(
                    CustomIcons.cancel,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Text(
                'GRADIENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.4,
                ),
              ),
              InkWell(
                onTap: toggleGradientSelector,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
    });
  }
}

class AudioGradientSelectorItem extends StatelessWidget {
  const AudioGradientSelectorItem(
      this.hexOne, this.hexTwo, this.setAudioGradientValues);

  final String hexOne;
  final String hexTwo;
  final Function setAudioGradientValues;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setAudioGradientValues(hexOne, hexTwo);
      },
      child: Container(
        height: 38,
        width: 38,
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(colors: [
            HexColor.fromHex(hexOne),
            HexColor.fromHex(hexTwo),
          ]),
        ),
      ),
    );
  }
}
