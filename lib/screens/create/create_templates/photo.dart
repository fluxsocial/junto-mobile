import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:provider/provider.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  const CreatePhoto({Key key, this.address, this.expressionContext})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto> with CreateExpressionHelpers {
  File preCroppedFile;
  File imageFile;
  ImageSource imageSource;
  FocusNode _captionFocus;
  bool _showBottomNav = true;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];

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
      _toggleBottomNav(false);
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
    _toggleBottomNav(false);
  }

  /// Creates a [PhotoFormExpression] from the given data entered
  /// by the user.
  Map<String, dynamic> createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);

    return <String, dynamic>{
      'image': imageFile,
      'caption': markupText.trim(),
      'mentions': mentions,
    };
  }

  bool _expressionHasData() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  void _onNext() {
    if (_expressionHasData() == true) {
      final Map<String, dynamic> expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            if (widget.expressionContext == ExpressionContext.Comment) {
              return CreateCommentActions(
                expression: expression,
                address: widget.address,
                expressionType: ExpressionType.photo,
              );
            } else {
              return CreateActions(
                expressionType: ExpressionType.photo,
                address: widget.address,
                expressionContext: widget.expressionContext,
                expression: expression,
              );
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Please add a photo.',
        ),
      );
      return;
    }
  }

  void _toggleBottomNav(bool value) {
    setState(() {
      _showBottomNav = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: CreateExpressionScaffold(
        expressionType: ExpressionType.photo,
        onNext: _onNext,
        showBottomNav: _showBottomNav,
        expressionHasData: _expressionHasData,
        child: Expanded(
          child: Container(
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
                                _onPickPressed(source: ImageSource.gallery);
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
                  if (imageFile == null) _uploadPhotoOptions()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadPhotoOptions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 100),
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
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final _users = getUserList(state, []);

        final _finalList = [...addedmentions, ..._users];
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
                              context
                                  .bloc<SearchBloc>()
                                  .add(SearchingEvent(value, true));
                            },
                            onSuggestionVisibleChanged: (val) {
                              setState(() {
                                _showList = val;
                              });
                            },
                            hideSuggestionList: true,
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
                            setState(() {
                              imageFile = null;
                            });
                            _onPickPressed(source: imageSource);
                            _toggleBottomNav(true);
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
              if (_showList) buildUserMention(context, _users),
            ],
          ),
        );
      },
    );
  }

  Positioned buildUserMention(
      BuildContext context, List<Map<String, dynamic>> _finalList) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .3,
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: _finalList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MemberPreview(
              onUserTap: () {
                mentionKey.currentState.addMention(_finalList[index]);

                if (addedmentions.indexWhere((element) =>
                        element['id'] == _finalList[index]['id']) ==
                    -1) {
                  addedmentions = [...addedmentions, _finalList[index]];
                }

                setState(() {
                  _showList = false;
                });
              },
              profile: UserProfile(
                username: _finalList[index]['display'],
                address: _finalList[index]['id'],
                profilePicture: [_finalList[index]['photo']],
                name: _finalList[index]['full_name'],
                verified: true,
                backgroundPhoto: _finalList[index]['backgroundPhoto'],
                badges: [],
                gender: [],
                website: [],
                bio: _finalList[index]['bio'],
                location: [],
              ),
            );
          },
        ),
      ),
    );
  }
}
