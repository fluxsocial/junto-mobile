import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_top_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_context_overlay.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/choose_expression_sheet.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/link.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:provider/provider.dart';

class CreateExpressionScaffold extends StatefulWidget {
  CreateExpressionScaffold({
    Key key,
    this.onNext,
    this.expressionHasData,
    this.expressionContext = ExpressionContext.Collective,
  }) : super(key: key);

  final VoidCallback onNext;
  final Function expressionHasData;
  final ExpressionContext expressionContext;

  @override
  State<StatefulWidget> createState() {
    return CreateExpressionScaffoldState();
  }
}

class CreateExpressionScaffoldState extends State<CreateExpressionScaffold> {
  UserData userData;
  ExpressionType currentExpressionType = ExpressionType.none;
  ExpressionContext expressionContext;
  bool chooseContextVisibility = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    expressionContext = widget.expressionContext;
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
        child = CreateLongform();
        break;

      case ExpressionType.shortform:
        child = CreateShortform();
        break;

      case ExpressionType.link:
        child = CreateLinkForm();
        break;

      case ExpressionType.photo:
        child = CreatePhoto();
        break;

      case ExpressionType.audio:
        child = CreateAudio();
        break;

      case ExpressionType.none:
        child = Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
        );
        break;

      default:
        child = CreateLongform();
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
              key: _scaffoldKey,
              body: JuntoFilterDrawer(
                leftDrawer: null,
                rightMenu: JuntoDrawer(),
                scaffold: Scaffold(
                  appBar: CreateAppBar(
                    onNext: widget.onNext,
                    expressionHasData: widget.expressionHasData,
                  ),
                  resizeToAvoidBottomPadding: false,
                  resizeToAvoidBottomInset: false,
                  body: Stack(
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
                ),
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
