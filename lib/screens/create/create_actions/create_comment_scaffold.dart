import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_top_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/choose_expression_sheet.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/link.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio.dart';
import 'package:junto_beta_mobile/screens/create/create_review/longform_review.dart';
import 'package:junto_beta_mobile/screens/create/create_review/shortform_review.dart';
import 'package:junto_beta_mobile/screens/create/create_review/photo_review.dart';
import 'package:junto_beta_mobile/screens/create/create_review/link_review.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/bloc/search_bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/screens/create/create_review/audio_review.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

class CreateCommentExpressionScaffold extends StatefulWidget {
  CreateCommentExpressionScaffold({
    Key key,
    this.expressionContext,
    this.group,
    this.commentAddress,
  }) : super(key: key);

  final ExpressionContext expressionContext;
  final Group group;
  final String commentAddress;

  @override
  State<StatefulWidget> createState() {
    return CreateCommentExpressionScaffoldState();
  }
}

class CreateCommentExpressionScaffoldState
    extends State<CreateCommentExpressionScaffold>
    with CreateExpressionHelpers {
  UserData userData;
  String socialContextAddress;
  ExpressionType currentExpressionType = ExpressionType.none;
  ExpressionContext expressionContext = ExpressionContext.Collective;
  PageController createPageController;
  int _currentIndex = 0;
  dynamic expression;
  List<String> channels = [];
  List<String> mentions = [];
  Group selectedGroup;
  bool showExpressionSheet = true;
  AudioService _audioService;

  final GlobalKey<CreateLongformState> _longformKey =
      GlobalKey<CreateLongformState>();
  final GlobalKey<CreateShortformState> _shortformKey =
      GlobalKey<CreateShortformState>();
  final GlobalKey<CreateLinkFormState> _linkKey =
      GlobalKey<CreateLinkFormState>();
  final GlobalKey<CreatePhotoState> _photoKey = GlobalKey<CreatePhotoState>();
  final GlobalKey<CreateAudioState> _audioKey = GlobalKey<CreateAudioState>();
  final GlobalKey<CreateEventState> _eventKey = GlobalKey<CreateEventState>();

  final FocusNode dynamicCaptionFocusNode = FocusNode();
  final FocusNode dynamicTitleFocusNode = FocusNode();
  final FocusNode shortformFocusNode = FocusNode();
  final FocusNode linkCaptionFocusNode = FocusNode();
  final FocusNode linkUrlFocusNode = FocusNode();
  final FocusNode photoCaptionFocusNode = FocusNode();
  final FocusNode audioCaptionFocusNode = FocusNode();
  final FocusNode audioTitleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    createPageController = PageController(initialPage: 0, keepPage: true);

    dynamicCaptionFocusNode.addListener(() {
      _toggleExpressionSheetVisibility(focusNode: dynamicCaptionFocusNode);
    });

    dynamicTitleFocusNode.addListener(() {
      _toggleExpressionSheetVisibility(focusNode: dynamicTitleFocusNode);
    });

    shortformFocusNode.addListener(() {
      _toggleExpressionSheetVisibility(focusNode: shortformFocusNode);
    });

    linkCaptionFocusNode.addListener(() {
      _toggleExpressionSheetVisibility(focusNode: linkCaptionFocusNode);
    });

    linkUrlFocusNode.addListener(() {
      _toggleExpressionSheetVisibility(focusNode: linkUrlFocusNode);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData =
        Provider.of<UserDataProvider>(context, listen: false).userProfile;
  }

  Widget _buildExpressionType() {
    Widget child;
    switch (currentExpressionType) {
      case ExpressionType.dynamic:
        child = CreateLongform(
          key: _longformKey,
          captionFocus: dynamicCaptionFocusNode,
          titleFocus: dynamicTitleFocusNode,
        );
        break;

      case ExpressionType.shortform:
        child = CreateShortform(
          key: _shortformKey,
          shortformFocus: shortformFocusNode,
        );
        break;

      case ExpressionType.link:
        child = CreateLinkForm(
          key: _linkKey,
          captionFocus: linkCaptionFocusNode,
          urlFocus: linkUrlFocusNode,
        );
        break;

      case ExpressionType.photo:
        child = CreatePhoto(
          key: _photoKey,
          toggleExpressionSheetVisibility: _toggleExpressionSheetVisibility,
          captionFocus: photoCaptionFocusNode,
        );
        break;

      case ExpressionType.audio:
        child = CreateAudio(
          key: _audioKey,
          captionFocus: audioCaptionFocusNode,
          titleFocus: audioTitleFocusNode,
        );

        break;

      case ExpressionType.none:
        child = SizedBox();
        break;

      default:
        child = CreateLongform(key: _longformKey);
        break;
    }
    return child;
  }

  removeFocus() {
    switch (currentExpressionType) {
      case ExpressionType.dynamic:
        dynamicCaptionFocusNode.unfocus();
        dynamicTitleFocusNode.unfocus();
        break;

      case ExpressionType.shortform:
        shortformFocusNode.unfocus();
        break;

      case ExpressionType.link:
        linkUrlFocusNode.unfocus();
        linkCaptionFocusNode.unfocus();
        break;

      case ExpressionType.photo:
        photoCaptionFocusNode.unfocus();
        break;

      case ExpressionType.audio:
        audioCaptionFocusNode.unfocus();
        audioTitleFocusNode.unfocus();
        break;

      case ExpressionType.none:
        break;

      default:
        break;
    }
  }

  _toggleExpressionSheetVisibility({FocusNode focusNode, bool visibility}) {
    // if there is a focus Node
    if (focusNode != null) {
      // if focus node has focus, hide the expression sheet
      if (focusNode.hasFocus) {
        setState(() {
          showExpressionSheet = false;
        });
        // If focus node doesn't have focus, show the expression sheet
      } else {
        setState(() {
          showExpressionSheet = true;
        });
      }
    } else {
      setState(() {
        showExpressionSheet = visibility;
      });
    }
  }

  _expressionHasData({Function function, @required String actionType}) {
    bool expressionHasData;
    String validationText;
    switch (currentExpressionType) {
      case ExpressionType.dynamic:
        expressionHasData = _longformKey.currentState.expressionHasData();
        validationText = 'Please fill in the required fields.';
        break;

      case ExpressionType.shortform:
        expressionHasData = _shortformKey.currentState.expressionHasData();
        validationText = "Please make sure the text field isn't blank.";

        break;

      case ExpressionType.link:
        expressionHasData = _linkKey.currentState.expressionHasData();
        validationText = 'Add a link before continuing.';
        break;

      case ExpressionType.photo:
        expressionHasData = _photoKey.currentState.expressionHasData();
        validationText = 'Please add a photo.';
        break;

      case ExpressionType.audio:
        expressionHasData =
            _audioKey.currentState.expressionHasData(_audioService);
        validationText = 'Record some audio before continuing.';
        break;

      default:
        expressionHasData = false;
        validationText = 'Please fill in the required fields.';
        break;
    }

    switch (actionType) {
      case 'leaveExpression':
        if (expressionHasData) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmDialog(
              confirmationText:
                  "Are you sure you want to leave this screen? Your expression won't be saved.",
              confirm: () {
                function();
              },
            ),
          );
        } else {
          function();
        }
        break;
      case 'continueExpression':
        if (!expressionHasData) {
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleActionDialog(
              context: context,
              dialogText: validationText,
            ),
          );
        } else {
          function();
        }
        break;
    }
  }

  Widget _buildReview() {
    Widget child;
    switch (currentExpressionType) {
      case ExpressionType.dynamic:
        child = CreateLongformReview(expression: expression);
        break;

      case ExpressionType.shortform:
        child = CreateShortformReview(expression: expression);
        break;

      case ExpressionType.link:
        child = CreateLinkFormReview(expression: expression);
        break;

      case ExpressionType.photo:
        child = CreatePhotoReview(expression: expression);
        break;

      case ExpressionType.audio:
        child = CreateAudioReview(expression: expression);
        break;

      case ExpressionType.none:
        child = SizedBox();
        break;

      default:
        child = CreateLongform(key: _longformKey);
        break;
    }
    return child;
  }

  void chooseExpressionType(ExpressionType newExpressionType) {
    _expressionHasData(
      function: () {
        setState(() {
          currentExpressionType = newExpressionType;
        });
      },
      actionType: 'leaveExpression',
    );
  }

  void togglePageView(int page) {
    if (page == 1) {
      dynamic expressionInProgress;
      Map<String, List<String>> mentionsAndChannels;

      switch (currentExpressionType) {
        case ExpressionType.dynamic:
          expressionInProgress = _longformKey.currentState.createExpression();
          mentionsAndChannels =
              _longformKey.currentState.getMentionsAndChannels();

          break;

        case ExpressionType.shortform:
          expressionInProgress = _shortformKey.currentState.createExpression();
          mentionsAndChannels =
              _shortformKey.currentState.getMentionsAndChannels();
          break;

        case ExpressionType.link:
          expressionInProgress = _linkKey.currentState.createExpression();
          mentionsAndChannels = _linkKey.currentState.getMentionsAndChannels();
          break;

        case ExpressionType.photo:
          expressionInProgress = _photoKey.currentState.createExpression();
          mentionsAndChannels = _photoKey.currentState.getMentionsAndChannels();
          break;

        case ExpressionType.audio:
          expressionInProgress =
              _audioKey.currentState.createExpression(_audioService);
          mentionsAndChannels = _audioKey.currentState.getMentionsAndChannels();
          break;
        case ExpressionType.event:
          expressionInProgress = _eventKey.currentState.createExpression();
          mentionsAndChannels = {'mentions': [], 'channels': []};
          break;

        case ExpressionType.none:
          break;

        default:
          break;
      }
      setState(() {
        expression = expressionInProgress;
        print('test: 2 $mentionsAndChannels');
        channels = mentionsAndChannels['channels'];
        mentions = mentionsAndChannels['mentions'];
      });
    }
    if (channels.length > 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          context: context,
          dialogText:
              'You can only add five channels. Please reduce the number of channels you have before continuing.',
        ),
      );
    } else {
      createPageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  Future<ExpressionModel> getAudioExpression(ExpressionRepo repository) async {
    final AudioFormExpression _expression =
        await repository.createAudio(expression);

    return ExpressionModel(
      type: currentExpressionType.modelName(),
      expressionData: _expression.toJson(),
      context: expressionContext,
      channels: channels,
      mentions: mentions,
    );
  }

  Future<ExpressionModel> getPhotoExpression(ExpressionRepo repository) async {
    final image = expression['image'];

    final photoKeys = await repository.createPhotoThumbnails(image);

    return ExpressionModel(
      type: currentExpressionType.modelName(),
      expressionData: PhotoFormExpression(
        image: photoKeys.keyPhoto,
        caption: expression['caption'],
        thumbnail300: photoKeys.key300,
        thumbnail600: photoKeys.key600,
      ).toJson(),
      context: expressionContext,
      channels: channels,
      mentions: mentions,
    );
  }

  Future<void> createExpression() async {
    ExpressionModel expressionModel;

    try {
      final repository = Provider.of<ExpressionRepo>(context, listen: false);

      switch (currentExpressionType) {
        case ExpressionType.photo:
          JuntoLoader.showLoader(context, color: Colors.white54);
          expressionModel = await getPhotoExpression(repository);
          JuntoLoader.hide();
          break;
        case ExpressionType.audio:
          JuntoLoader.showLoader(context, color: Colors.white54);
          expressionModel = await getAudioExpression(repository);
          JuntoLoader.hide();
          break;

        default:
          expressionModel = ExpressionModel(
            type: currentExpressionType.modelName(),
            expressionData: expression.toJson(),
            context: expressionContext,
            channels: channels,
            mentions: mentions,
          );

          break;
      }

      // Create expression
      JuntoLoader.showLoader(context);

      await Provider.of<ExpressionRepo>(context, listen: false)
          .postCommentExpression(
        widget.commentAddress,
        expressionModel.type,
        {
          ...expressionModel.expressionData,
          'mentions': mentions,
          'channels': channels,
        },
      );
      JuntoLoader.hide();

      // Show user feedback that expression was created
      await showFeedback(
        context,
        icon: Icon(
          CustomIcons.newcreate,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        message: 'Expression Created!',
      );

      Navigator.pop(context);
    } on DioError catch (error) {
      JuntoLoader.hide();

      // Handle max number of posts/day error
      if (error.response.statusCode == 429) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText:
                'You can only post to the Collective 5 times every 24 hours. Please try again soon.',
          ),
        );
      } else if (error.response.data
          .toString()
          .contains('No more than 5 channels allowed')) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
              dialogText: 'You can only add up to 5 channels.'),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.response.data.toString(),
          ),
        );
      }
    } catch (error) {
      print('test: $error');
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    createPageController.dispose();
    dynamicCaptionFocusNode.dispose();
    dynamicTitleFocusNode.dispose();
    shortformFocusNode.dispose();
    linkCaptionFocusNode.dispose();
    linkUrlFocusNode.dispose();
    photoCaptionFocusNode.dispose();
    audioTitleFocusNode.dispose();
    audioCaptionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: ChangeNotifierProvider<AudioService>(
        create: (context) => AudioService(),
        child: Consumer<AudioService>(builder: (context, audio, child) {
          _audioService = audio;
          return BlocProvider(
            create: (BuildContext context) {
              return SearchBloc(
                  Provider.of<SearchRepo>(context, listen: false));
            },
            child: Stack(
              children: [
                Scaffold(
                  appBar: CreateAppBar(
                    closeCreate: () {
                      Navigator.pop(context);
                    },
                    expressionHasData: _expressionHasData,
                    togglePageView: togglePageView,
                    currentIndex: _currentIndex,
                    createExpression: createExpression,
                    removeFocus: removeFocus,
                  ),
                  resizeToAvoidBottomInset: false,
                  body: WillPopScope(
                    onWillPop: () async {
                      _expressionHasData(
                        function: () async {
                          await Navigator.pop(context);
                        },
                        actionType: 'leaveExpression',
                      );
                      return false;
                    },
                    child: PageView(
                      controller: createPageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: [
                        // Create Screen 1 - Make Content
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  CreateTopBar(
                                    profilePicture:
                                        userData.user.profilePicture,
                                    currentExpressionContext: expressionContext,
                                    selectedGroup: selectedGroup,
                                    hideContextSelector: true,
                                  ),
                                  _buildExpressionType(),
                                ],
                              ),
                            ),
                            if (showExpressionSheet)
                              if (!_audioService.playBackAvailable)
                                ChooseExpressionSheet(
                                  currentExpressionType: currentExpressionType,
                                  chooseExpressionType: chooseExpressionType,
                                ),
                          ],
                        ),

                        // Create Screen 2 - Review Content
                        // We show a sized box when PageView index is 0 so we don't display a review screen
                        // that is not consistent with the expression type, which causes an error
                        if (_currentIndex == 0)
                          SizedBox()
                        else
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    CreateTopBar(
                                      profilePicture:
                                          userData.user.profilePicture,
                                      toggleSocialContextVisibility: () {},
                                      currentExpressionContext:
                                          expressionContext,
                                      selectedGroup: selectedGroup,
                                      hideContextSelector: true,
                                    ),
                                    _buildReview(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
