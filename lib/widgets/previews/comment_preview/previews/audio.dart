import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:provider/provider.dart';

class AudioPreview extends StatelessWidget {
  AudioPreview({@required this.comment});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final audioCaption = comment.expressionData.caption.trim();
    final audioTitle = comment.expressionData.title.trim();
    final audioGradients = comment.expressionData.gradient;
    final audioPhoto = comment.expressionData.thumbnail600;

    Widget _displayAudioPreview() {
      if (audioGradients.isEmpty && audioPhoto.isEmpty) {
        return AudioPreviewDefault(
          title: audioTitle,
        );
      } else if (audioPhoto.isNotEmpty) {
        return AudioPreviewWithPhoto(
          title: audioTitle,
          photo: audioPhoto,
        );
      } else if (audioGradients.isNotEmpty && audioGradients.length == 2) {
        return AudioPreviewWithGradients(
          gradients: audioGradients,
          title: audioTitle,
        );
      } else {
        return AudioPreviewDefault(title: audioTitle);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: _displayAudioPreview(),
        ),
        if (audioCaption.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: ParsedText(
              text: audioCaption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
              parse: [
                MatchText(
                  pattern: r"\[(@[^:]+):([^\]]+)\]",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                  renderText: ({String str, String pattern}) {
                    Map<String, String> map = <String, String>{};
                    RegExp customRegExp = RegExp(pattern);
                    Match match = customRegExp.firstMatch(str);
                    map['display'] = match.group(1);
                    map['value'] = match.group(2);
                    return map;
                  },
                  onTap: (url) async {
                    final userData =
                        await Provider.of<UserRepo>(context, listen: false)
                            .getUser(url);

                    Navigator.push(
                      context,
                      CupertinoPageRoute<Widget>(
                        builder: (BuildContext context) => JuntoMember(
                          profile: userData.user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AudioPreviewWaveform extends StatelessWidget {
  AudioPreviewWaveform({this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/junto-mobile__waveform.png',
      height: 38,
      color: color,
    );
  }
}

class AudioPreviewTitle extends StatelessWidget {
  AudioPreviewTitle({this.title, this.color});
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class AudioPreviewDefault extends StatelessWidget {
  AudioPreviewDefault({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Theme.of(context).primaryColor,
            ),
          AudioPreviewWaveform(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

class AudioPreviewWithGradients extends StatelessWidget {
  AudioPreviewWithGradients({this.title, this.gradients});
  final String title;
  final List<String> gradients;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[
              0.1,
              0.9
            ],
            colors: <Color>[
              HexColor.fromHex(gradients[0]),
              HexColor.fromHex(gradients[1]),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Colors.white,
            ),
          AudioPreviewWaveform(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class AudioPreviewWithPhoto extends StatelessWidget {
  AudioPreviewWithPhoto({this.title, this.photo});
  final String title;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 2 / 3,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black38,
            BlendMode.srcOver,
          ),
          image: CachedNetworkImageProvider(
            photo,
            cacheManager: CustomCacheManager(),
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (title.isNotEmpty)
            AudioPreviewTitle(
              title: title,
              color: Colors.white,
            ),
          AudioPreviewWaveform(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
