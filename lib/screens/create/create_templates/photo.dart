import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  const CreatePhoto({
    Key key,
    this.toggleExpressionSheetVisibility,
  }) : super(key: key);

  final Function toggleExpressionSheetVisibility;

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto>
    with CreateExpressionHelpers, AutomaticKeepAliveClientMixin {
  File preCroppedFile;
  File imageFile;
  ImageSource imageSource;
  FocusNode _captionFocus;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> completeUserList = [];
  List<Map<String, dynamic>> addedChannels = [];
  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> completeChannelsList = [];
  ListType listType = ListType.empty;

  Future<void> _onPickPressed({@required ImageSource source}) async {
    try {
      final imagePicker = ImagePicker();
      File image;
      if (source == ImageSource.gallery) {
        final pickedImage = await imagePicker.getImage(
          source: ImageSource.gallery,
          imageQuality: 70,
        );
        image = File(pickedImage.path);

        setState(() {
          imageSource = ImageSource.gallery;
        });
      } else if (source == ImageSource.camera) {
        final pickedImage = await imagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 70,
        );
        image = File(pickedImage.path);

        setState(() {
          imageSource = ImageSource.camera;
        });
      }

      if (image == null) {
        setState(() {
          imageFile = null;
        });
        return;
      } else {
        setState(() {
          preCroppedFile = image;
        });
      }

      final File cropped = await ImageCroppingDialog.show(
        context,
        image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ],
      );
      if (cropped == null) {
        setState(() {
          imageFile = null;
        });
        _onPickPressed(source: imageSource);
        return;
      }
      setState(() {
        imageFile = cropped;
      });
      widget.toggleExpressionSheetVisibility(visibility: false);
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Future<void> _cropPhoto() async {
    final File image = preCroppedFile;
    final File cropped = await ImageCroppingDialog.show(context, image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ]);
    if (cropped == null) {
      return;
    }
    setState(() => imageFile = cropped);
  }

  /// Creates a [PhotoFormExpression] from the given data entered
  /// by the user.
  Map<String, dynamic> createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;

    return <String, dynamic>{
      'image': imageFile,
      'caption': markupText.trim(),
    };
  }

  Map<String, List<String>> getMentionsAndChannels() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);
    final channels = getChannelsId(markupText);
    return <String, List<String>>{
      'mentions': mentions,
      'channels': channels,
    };
  }

  bool expressionHasData() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  void toggleSearch(bool value) {
    if (value != _showList) {
      setState(() {
        _showList = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: Expanded(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: imageFile == null
                    ? Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              builder: (BuildContext context) => Container(
                                color: Colors.transparent,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .36,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .1,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              _onPickPressed(
                                                source: ImageSource.gallery,
                                              );
                                            },
                                            title: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.photo_library,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 17,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Library',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              _onPickPressed(
                                                source: ImageSource.camera,
                                              );
                                            },
                                            title: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.photo_library,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 17,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Camera',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                CustomIcons.add,
                                size: 75,
                              ),
                            ],
                          ),
                        ),
                      )
                    : _captionPhoto(),
              ),
              // if (imageFile == null) _uploadPhotoOptions()
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadPhotoOptions() {
    return Container(
      decoration: BoxDecoration(
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
            onTap: () {
              _onPickPressed(source: ImageSource.gallery);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.center,
              child: Text(
                'LIBRARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.7,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _onPickPressed(source: ImageSource.camera);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.center,
              child: Text(
                'CAMERA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _captionPhoto() {
    return BlocConsumer<SearchBloc, SearchState>(
      buildWhen: (prev, cur) {
        return !(cur is LoadingSearchState || cur is LoadingSearchChannelState);
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

              completeUserList = generateFinalList(completeUserList, _users);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Image.file(imageFile),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: FlutterMentions(
                            key: mentionKey,
                            focusNode: _captionFocus,
                            onSearchChanged: (String trigger, String value) {
                              if (value.isNotEmpty && _showList) {
                                final channel = trigger == '#';

                                if (!channel) {
                                  context.bloc<SearchBloc>().add(SearchingEvent(
                                        value,
                                        QueryUserBy.BOTH,
                                      ));
                                } else {
                                  context
                                      .bloc<SearchBloc>()
                                      .add(SearchingChannelEvent(value));
                                }
                              } else {
                                setState(() {
                                  users = [];
                                  channels = [];
                                  listType = ListType.empty;
                                  _showList = false;
                                });
                              }
                            },
                            onSuggestionVisibleChanged: toggleSearch,
                            hideSuggestionList: true,
                            mentions: getMention(
                              context,
                              [...addedmentions, ...completeUserList],
                              [...addedChannels, ...completeChannelsList],
                            ),
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 1,
                            maxLines: null,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 17,
                                ),
                            keyboardAppearance: Theme.of(context).brightness,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                confirmationText:
                                    'Are you sure you want to leave this screen? Your expression will not be saved.',
                                confirm: () {
                                  setState(() {
                                    imageFile = null;
                                  });
                                  widget.toggleExpressionSheetVisibility(
                                      visibility: true);
                                  _onPickPressed(source: imageSource);
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async => _cropPhoto(),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.crop,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
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
                      mentionKey.currentState.addMention(users[index]);

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
                      mentionKey.currentState.addMention(channels[index]);

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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
