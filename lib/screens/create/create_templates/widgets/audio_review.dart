import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:provider/provider.dart';

class AudioReview extends StatefulWidget {
  AudioReview({
    this.audioPhotoBackground,
    this.audioGradientValues,
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.mentionKey,
  });
  final File audioPhotoBackground;
  final List<String> audioGradientValues;
  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  _AudioReviewState createState() => _AudioReviewState();
}

class _AudioReviewState extends State<AudioReview>
    with CreateExpressionHelpers {
  bool _showList = false;

  List<Map<String, dynamic>> addedmentions = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return BlocProvider(
        create: (BuildContext context) {
          return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            final _users = getUserList(state, []);
            final _finalList = [...addedmentions, ..._users];

            return Container(
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            _showAudioReviewTemplate(),
                          ],
                        ),
                      ),
                      if (widget.captionFocus.hasFocus)
                        AudioUnfocus(
                          captionFocus: widget.captionFocus,
                        ),
                    ],
                  ),
                  if (_showList)
                    MentionsSearchList(
                      userList: _users,
                      onMentionAdd: (index) {
                        widget.mentionKey.currentState
                            .addMention(_finalList[index]);

                        if (addedmentions.indexWhere((element) =>
                                element['id'] == _finalList[index]['id']) ==
                            -1) {
                          addedmentions = [...addedmentions, _finalList[index]];
                        }

                        setState(() {
                          _showList = false;
                        });
                      },
                    ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  void toggleSearch(bool value) {
    setState(() {
      _showList = value;
    });
  }

  Widget _showAudioReviewTemplate() {
    if (widget.audioPhotoBackground == null &&
        widget.audioGradientValues.isEmpty) {
      return AudioReviewDefault(
        titleController: widget.titleController,
        captionController: widget.captionController,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        addedmentions: addedmentions,
        mentionKey: widget.mentionKey,
      );
    } else if (widget.audioPhotoBackground != null &&
        widget.audioGradientValues.isEmpty) {
      return AudioReviewWithPhoto(
        titleController: widget.titleController,
        captionController: widget.captionController,
        audioPhotoBackground: widget.audioPhotoBackground,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        addedmentions: addedmentions,
        mentionKey: widget.mentionKey,
      );
    } else if (widget.audioPhotoBackground == null &&
        widget.audioGradientValues.isNotEmpty) {
      return AudioReviewWithGradient(
        titleController: widget.titleController,
        captionController: widget.captionController,
        audioGradientValues: widget.audioGradientValues,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        addedmentions: addedmentions,
        mentionKey: widget.mentionKey,
      );
    } else {
      return AudioReviewDefault(
        captionController: widget.captionController,
        titleController: widget.titleController,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        addedmentions: addedmentions,
        mentionKey: widget.mentionKey,
      );
    }
  }
}

class AudioReviewDefault extends StatelessWidget {
  AudioReviewDefault({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.toggleSearch,
    this.addedmentions,
    this.mentionKey,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> addedmentions;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AudioReviewBody(
          hasBackground: false,
          titleController: titleController,
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
          toggleSearch: toggleSearch,
          addedmentions: addedmentions,
          mentionKey: mentionKey,
        ),
      ],
    );
  }
}

class AudioReviewWithGradient extends StatelessWidget {
  AudioReviewWithGradient({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.audioGradientValues,
    this.toggleSearch,
    this.addedmentions,
    this.mentionKey,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final List<String> audioGradientValues;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> addedmentions;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: <double>[0.2, 0.9],
              colors: <Color>[
                HexColor.fromHex(audioGradientValues[0]),
                HexColor.fromHex(audioGradientValues[1]),
              ],
            ),
          ),
          child: AudioReviewBody(
            hasBackground: true,
            titleController: titleController,
          ),
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
          toggleSearch: toggleSearch,
          addedmentions: addedmentions,
          mentionKey: mentionKey,
        ),
      ],
    );
  }
}

class AudioReviewWithPhoto extends StatelessWidget {
  AudioReviewWithPhoto({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.audioPhotoBackground,
    this.toggleSearch,
    this.addedmentions,
    this.mentionKey,
  });

  final titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final File audioPhotoBackground;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> addedmentions;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Image.file(
              audioPhotoBackground,
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: AudioTitle(
              titleController: titleController,
              hasBackground: true,
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: AudioPlaybackRow(
                hasBackground: true,
              ),
            ),
          ),
        ]),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
          toggleSearch: toggleSearch,
          addedmentions: addedmentions,
          mentionKey: mentionKey,
        ),
      ],
    );
  }
}

class AudioReviewBody extends StatelessWidget {
  AudioReviewBody({
    this.titleController,
    this.hasBackground,
  });
  final TextEditingController titleController;
  final bool hasBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: hasBackground ? Colors.black45 : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AudioTitle(
            titleController: titleController,
            hasBackground: hasBackground,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AudioPlaybackRow(
              hasBackground: hasBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioTitle extends StatelessWidget {
  const AudioTitle({
    Key key,
    @required this.titleController,
    @required this.hasBackground,
  }) : super(key: key);

  final TextEditingController titleController;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: titleController,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintMaxLines: 25,
          hintStyle: TextStyle(
            color:
                hasBackground ? Colors.white : Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          hintText: S.of(context).audio_title,
          counter: SizedBox(),
        ),
        cursorColor:
            hasBackground ? Colors.white : Theme.of(context).primaryColor,
        cursorWidth: 2,
        maxLines: null,
        style: TextStyle(
          color: hasBackground ? Colors.white : Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        maxLength: 80,
        textInputAction: TextInputAction.done,
        keyboardAppearance: Theme.of(context).brightness,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

class AudioCaption extends StatelessWidget with CreateExpressionHelpers {
  AudioCaption({
    Key key,
    @required this.captionController,
    @required this.captionFocus,
    this.toggleSearch,
    this.addedmentions,
    this.mentionKey,
  }) : super(key: key);

  final TextEditingController captionController;
  final FocusNode captionFocus;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> addedmentions;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final _users = getUserList(state, []);

        final _finalList = [...addedmentions, ..._users];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FlutterMentions(
            key: mentionKey,
            focusNode: captionFocus,
            autofocus: false,
            onSearchChanged: (String trigger, String value) {
              context.bloc<SearchBloc>().add(SearchingEvent(value, true));
            },
            onSuggestionVisibleChanged: toggleSearch,
            mentions: [
              Mention(
                trigger: '@',
                data: [..._finalList],
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w700,
                ),
                markupBuilder: (trigger, mention, value) {
                  return '[$trigger$value:$mention]';
                },
              ),
            ],
            hideSuggestionList: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              hintText: 'Write a caption...',
              counter: SizedBox(),
            ),
            cursorColor: Theme.of(context).primaryColor,
            cursorWidth: 2,
            maxLines: null,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            textInputAction: TextInputAction.newline,
            keyboardAppearance: Theme.of(context).brightness,
            textCapitalization: TextCapitalization.sentences,
          ),
        );
      },
    );
  }
}

class AudioUnfocus extends StatelessWidget {
  const AudioUnfocus({this.captionFocus});
  final FocusNode captionFocus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: captionFocus.unfocus,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Icon(
          Icons.keyboard_arrow_down,
          size: 24,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
