import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
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
    this.titleFocus,
    this.mentionKey,
  });
  final File audioPhotoBackground;
  final List<String> audioGradientValues;
  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final FocusNode titleFocus;
  final GlobalKey<FlutterMentionsState> mentionKey;

  @override
  _AudioReviewState createState() => _AudioReviewState();
}

class _AudioReviewState extends State<AudioReview>
    with CreateExpressionHelpers {
  bool _showList = false;

  List<Map<String, dynamic>> addedmentions = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> completeUserList = [];
  List<Map<String, dynamic>> addedChannels = [];
  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> completeChannelsList = [];
  ListType listType = ListType.empty;

  void onSearchChanged(BuildContext context, String trigger, String value) {
    if (value.isNotEmpty && _showList) {
      final channel = trigger == '#';

      if (!channel) {
        context.read<SearchBloc>().add(SearchingEvent(
              value,
              QueryUserBy.BOTH,
            ));
      } else {
        context.read<SearchBloc>().add(SearchingChannelEvent(value));
      }
    } else {
      setState(() {
        _showList = false;
        users = [];
        channels = [];
        listType = ListType.empty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return BlocProvider(
        create: (BuildContext context) {
          return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
        },
        child: BlocConsumer<SearchBloc, SearchState>(
          buildWhen: (prev, cur) {
            return !(cur is LoadingSearchState ||
                cur is LoadingSearchChannelState);
          },
          listener: (context, state) {
            if (!(state is LoadingSearchState) && (state is SearchUserState)) {
              final eq = DeepCollectionEquality.unordered().equals;

              final _users = getUserList(state, []);

              final isEqual = eq(users, _users);

              if (!isEqual) {
                setState(() {
                  users = _users;

                  listType = ListType.mention;

                  completeUserList =
                      generateFinalList(completeUserList, _users);
                });
              }
            }

            if (!(state is LoadingSearchChannelState) &&
                (state is SearchChannelState)) {
              final eq = DeepCollectionEquality.unordered().equals;

              final _channels = getChannelsList(state, []);

              final isEqual = eq(channels, _channels);

              if (!isEqual) {
                setState(() {
                  channels = _channels;

                  listType = ListType.channels;

                  completeChannelsList =
                      generateFinalList(completeChannelsList, _channels);
                });
              }
            }
          },
          builder: (context, state) {
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
                  if (_showList && listType == ListType.mention)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: MentionsSearchList(
                        userList: users,
                        onMentionAdd: (index) {
                          widget.mentionKey.currentState
                              .addMention(users[index]);

                          if (addedmentions.indexWhere((element) =>
                                  element['id'] == users[index]['id']) ==
                              -1) {
                            addedmentions = [...addedmentions, users[index]];
                          }

                          setState(() {
                            _showList = false;
                            users = [];
                          });
                        },
                      ),
                    ),
                  if (_showList && listType == ListType.channels)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: ChannelsSearchList(
                        channels: channels,
                        onChannelAdd: (index) {
                          widget.mentionKey.currentState
                              .addMention(channels[index]);

                          if (addedChannels.indexWhere((element) =>
                                  element['id'] == channels[index]['id']) ==
                              -1) {
                            addedChannels = [...addedChannels, channels[index]];
                          }

                          setState(() {
                            _showList = false;
                            channels = [];
                          });
                        },
                      ),
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
    if (value != _showList) {
      setState(() {
        _showList = value;
      });
    }
  }

  Widget _showAudioReviewTemplate() {
    final completeMentionList = [...addedmentions, ...completeUserList];
    final completeChannelList = [...addedChannels, ...completeChannelsList];

    if (widget.audioPhotoBackground == null &&
        widget.audioGradientValues.isEmpty) {
      return AudioReviewDefault(
        titleController: widget.titleController,
        captionController: widget.captionController,
        captionFocus: widget.captionFocus,
        titleFocus: widget.titleFocus,
        toggleSearch: toggleSearch,
        completeMentionList: completeMentionList,
        completeChannelList: completeChannelList,
        onSearchChanged: onSearchChanged,
        mentionKey: widget.mentionKey,
        showList: _showList,
      );
    } else if (widget.audioPhotoBackground != null &&
        widget.audioGradientValues.isEmpty) {
      return AudioReviewWithPhoto(
        titleController: widget.titleController,
        captionController: widget.captionController,
        audioPhotoBackground: widget.audioPhotoBackground,
        titleFocus: widget.titleFocus,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        completeMentionList: completeMentionList,
        completeChannelList: completeChannelList,
        onSearchChanged: onSearchChanged,
        mentionKey: widget.mentionKey,
        showList: _showList,
      );
    } else if (widget.audioPhotoBackground == null &&
        widget.audioGradientValues.isNotEmpty) {
      return AudioReviewWithGradient(
        titleController: widget.titleController,
        captionController: widget.captionController,
        audioGradientValues: widget.audioGradientValues,
        titleFocus: widget.titleFocus,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        completeMentionList: completeMentionList,
        completeChannelList: completeChannelList,
        onSearchChanged: onSearchChanged,
        mentionKey: widget.mentionKey,
        showList: _showList,
      );
    } else {
      return AudioReviewDefault(
        captionController: widget.captionController,
        titleController: widget.titleController,
        titleFocus: widget.titleFocus,
        captionFocus: widget.captionFocus,
        toggleSearch: toggleSearch,
        completeMentionList: completeMentionList,
        mentionKey: widget.mentionKey,
        completeChannelList: completeChannelList,
        onSearchChanged: onSearchChanged,
        showList: _showList,
      );
    }
  }
}

class AudioReviewDefault extends StatelessWidget {
  AudioReviewDefault({
    this.titleController,
    this.captionController,
    this.captionFocus,
    this.titleFocus,
    this.toggleSearch,
    this.completeMentionList,
    this.mentionKey,
    this.showList,
    this.completeChannelList,
    this.onSearchChanged,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final FocusNode titleFocus;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> completeMentionList;
  final List<Map<String, dynamic>> completeChannelList;
  final Function onSearchChanged;
  final GlobalKey<FlutterMentionsState> mentionKey;
  final bool showList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AudioReviewBody(
          hasBackground: false,
          titleController: titleController,
          titleFocus: titleFocus,
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
          toggleSearch: toggleSearch,
          completeMentionList: completeMentionList,
          mentionKey: mentionKey,
          showList: showList,
          completeChannelList: completeChannelList,
          onSearchChanged: onSearchChanged,
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
    this.titleFocus,
    this.audioGradientValues,
    this.toggleSearch,
    this.completeMentionList,
    this.mentionKey,
    this.showList,
    this.completeChannelList,
    this.onSearchChanged,
  });

  final TextEditingController titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final FocusNode titleFocus;
  final List<String> audioGradientValues;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> completeMentionList;
  final List<Map<String, dynamic>> completeChannelList;
  final Function onSearchChanged;
  final GlobalKey<FlutterMentionsState> mentionKey;
  final bool showList;

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
            titleFocus: titleFocus,
          ),
        ),
        AudioCaption(
          captionController: captionController,
          captionFocus: captionFocus,
          toggleSearch: toggleSearch,
          completeMentionList: completeMentionList,
          mentionKey: mentionKey,
          showList: showList,
          completeChannelList: completeChannelList,
          onSearchChanged: onSearchChanged,
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
    this.titleFocus,
    this.audioPhotoBackground,
    this.toggleSearch,
    this.completeMentionList,
    this.mentionKey,
    this.showList,
    this.completeChannelList,
    this.onSearchChanged,
  });

  final titleController;
  final TextEditingController captionController;
  final FocusNode captionFocus;
  final FocusNode titleFocus;

  final File audioPhotoBackground;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> completeMentionList;
  final List<Map<String, dynamic>> completeChannelList;
  final Function onSearchChanged;
  final GlobalKey<FlutterMentionsState> mentionKey;
  final bool showList;

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
              titleFocus: titleFocus,
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
          completeMentionList: completeMentionList,
          mentionKey: mentionKey,
          showList: showList,
          completeChannelList: completeChannelList,
          onSearchChanged: onSearchChanged,
        ),
      ],
    );
  }
}

class AudioReviewBody extends StatelessWidget {
  AudioReviewBody({
    this.titleController,
    this.hasBackground,
    this.titleFocus,
  });
  final TextEditingController titleController;
  final bool hasBackground;
  final FocusNode titleFocus;
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
            titleFocus: titleFocus,
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
    @required this.titleFocus,
  }) : super(key: key);

  final TextEditingController titleController;
  final bool hasBackground;
  final FocusNode titleFocus;

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
        focusNode: titleFocus,
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
    this.completeMentionList,
    this.mentionKey,
    this.showList,
    this.completeChannelList,
    this.onSearchChanged,
  }) : super(key: key);

  final TextEditingController captionController;
  final FocusNode captionFocus;
  final Function(bool) toggleSearch;
  final List<Map<String, dynamic>> completeMentionList;
  final List<Map<String, dynamic>> completeChannelList;
  final GlobalKey<FlutterMentionsState> mentionKey;
  final bool showList;
  final Function onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FlutterMentions(
            key: mentionKey,
            focusNode: captionFocus,
            autofocus: false,
            onSearchChanged: (String trigger, String value) {
              onSearchChanged(context, trigger, value);
            },
            onSuggestionVisibleChanged: toggleSearch,
            mentions: getMention(
              context,
              completeMentionList,
              completeChannelList,
            ),
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
