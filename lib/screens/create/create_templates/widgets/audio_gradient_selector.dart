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
    final List<Map<String, String>> audioGradients = [
      {
        'first': '8E8098',
        'second': '307FAA',
      },
      {
        'first': '6F51A8',
        'second': 'E8B974',
      },
      {
        'first': '2E4F78',
        'second': '6397C7',
      },
      {
        'first': '719cf4',
        'second': 'ffc7e4',
      },
      {
        'first': '639acf',
        'second': '7bdaa5',
      },
      {
        'first': 'FC6073',
        'second': 'FFD391',
      },
      {
        'first': '2CBAB1',
        'second': 'E7E26E',
      },
      {
        'first': '222222',
        'second': '555555',
      },
      {
        'first': 'BD96D6',
        'second': '2034BC',
      },
    ];

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
                children: audioGradients
                    .map(
                      (audioGradient) => AudioGradientSelectorItem(
                          audioGradient['first'],
                          audioGradient['second'],
                          setAudioGradientValues),
                    )
                    .toList(),
              )),
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
                  color: Colors.transparent,
                  child: Icon(
                    CustomIcons.cancel,
                    size: 22,
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
                  color: Colors.transparent,
                  child: Icon(
                    Icons.check,
                    size: 22,
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
