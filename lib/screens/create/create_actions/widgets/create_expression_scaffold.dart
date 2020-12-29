import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_top_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_context_overlay.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/choose_expression_sheet.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
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
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:provider/provider.dart';

class CreateExpressionScaffold extends StatefulWidget {
  CreateExpressionScaffold({
    Key key,
    this.closeCreate,
  }) : super(key: key);

  final Function closeCreate;
  @override
  State<StatefulWidget> createState() {
    return CreateExpressionScaffoldState();
  }
}

class CreateExpressionScaffoldState extends State<CreateExpressionScaffold> {
  UserData userData;
  ExpressionType currentExpressionType = ExpressionType.none;
  ExpressionContext expressionContext = ExpressionContext.Collective;
  bool chooseContextVisibility = false;
  PageController createPageController;
  int _currentIndex = 0;
  dynamic expression;

  final GlobalKey<CreateLongformState> _longformKey =
      GlobalKey<CreateLongformState>();
  final GlobalKey<CreateShortformState> _shortformKey =
      GlobalKey<CreateShortformState>();
  final GlobalKey<CreateLinkFormState> _linkKey =
      GlobalKey<CreateLinkFormState>();
  final GlobalKey<CreatePhotoState> _photoKey = GlobalKey<CreatePhotoState>();
  final GlobalKey<CreateAudioState> _audioKey = GlobalKey<CreateAudioState>();

  @override
  void initState() {
    super.initState();
    createPageController = PageController(initialPage: 0);
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
        child = CreateLongform(key: _longformKey);
        break;

      case ExpressionType.shortform:
        child = CreateShortform(key: _shortformKey);
        break;

      case ExpressionType.link:
        child = CreateLinkForm(key: _linkKey);
        break;

      case ExpressionType.photo:
        child = CreatePhoto(key: _photoKey);
        break;

      case ExpressionType.audio:
        child = CreateAudio(key: _audioKey);
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
        child = CreateLinkForm(key: _linkKey);
        break;

      case ExpressionType.photo:
        child = CreatePhoto(key: _photoKey);
        break;

      case ExpressionType.audio:
        child = CreateAudio(key: _audioKey);
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
    setState(() {
      currentExpressionType = newExpressionType;
    });
  }

  void toggleSocialContextVisibility(bool value) {
    setState(() {
      chooseContextVisibility = value;
    });
  }

  void selectExpressionContext(ExpressionContext newExpressionContext) {
    setState(() {
      expressionContext = newExpressionContext;
    });
  }

  void closeCreation() {
    setState(() {});
  }

  void togglePageView(int page) {
    createPageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    if (page == 1) {
      dynamic expressionInProgress;

      switch (currentExpressionType) {
        case ExpressionType.dynamic:
          expressionInProgress = _longformKey.currentState.createExpression();

          break;

        case ExpressionType.shortform:
          expressionInProgress = _shortformKey.currentState.createExpression();

          break;

        case ExpressionType.link:
          expressionInProgress = _linkKey.currentState.createExpression();

          break;

        case ExpressionType.photo:
          expressionInProgress = _photoKey.currentState.createExpression();

          break;

        // case ExpressionType.audio:
        //   expressionInProgress = _audioKey.currentState.createExpression();

        //   break;

        case ExpressionType.none:
          break;

        default:
          break;
      }
      setState(() {
        expression = expressionInProgress;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    createPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: BlocProvider(
        create: (BuildContext context) {
          return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: CreateAppBar(
                closeCreate: widget.closeCreate,
                togglePageView: togglePageView,
                currentIndex: _currentIndex,
              ),
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              body: PageView(
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
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * .1,
                        ),
                        child: Column(
                          children: <Widget>[
                            CreateTopBar(
                              profilePicture: userData.user.profilePicture,
                              toggleSocialContextVisibility:
                                  toggleSocialContextVisibility,
                              currentExpressionContext: expressionContext,
                            ),
                            _buildExpressionType(),
                          ],
                        ),
                      ),
                      ChooseExpressionSheet(
                        currentExpressionType: currentExpressionType,
                        chooseExpressionType: chooseExpressionType,
                      ),
                    ],
                  ),

                  // Create Screen 2 - Review Content
                  Column(
                    children: [
                      CreateTopBar(
                        profilePicture: userData.user.profilePicture,
                        toggleSocialContextVisibility:
                            toggleSocialContextVisibility,
                        currentExpressionContext: expressionContext,
                      ),
                      _buildReview(),
                    ],
                  ),
                ],
              ),
            ),
            if (chooseContextVisibility)
              CreateContextOverlay(
                currentExpressionContext: expressionContext,
                selectExpressionContext: selectExpressionContext,
                toggleSocialContextVisibility: toggleSocialContextVisibility,
              ),
          ],
        ),
      ),
    );
  }
}
