import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_app_bar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_top_bar.dart';
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
  }) : super(key: key);

  final VoidCallback onNext;
  final Function expressionHasData;

  @override
  State<StatefulWidget> createState() {
    return CreateExpressionScaffoldState();
  }
}

class CreateExpressionScaffoldState extends State<CreateExpressionScaffold> {
  UserData userData;
  ExpressionType currentExpressionType = ExpressionType.none;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: BlocProvider(
        create: (BuildContext context) {
          return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
        },
        child: Scaffold(
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
                        ),
                        _buildExpressionType(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: DraggableScrollableSheet(
                            minChildSize: .1,
                            maxChildSize: .3,
                            initialChildSize: .3,
                            builder: (context, scrollController) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: .75,
                                    ),
                                  ),
                                ),
                                child: ListView(
                                  controller: scrollController,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 7.5,
                                          width: 100,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).dividerColor,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Icon(
                                        CustomIcons.create,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      color: Theme.of(context).backgroundColor,
                                      child: Row(
                                        children: [
                                          CreateExpressionIcon(
                                            expressionType:
                                                ExpressionType.dynamic,
                                            currentExpressionType:
                                                currentExpressionType,
                                            switchExpressionType:
                                                chooseExpressionType,
                                          ),
                                          CreateExpressionIcon(
                                            expressionType:
                                                ExpressionType.shortform,
                                            currentExpressionType:
                                                currentExpressionType,
                                            switchExpressionType:
                                                chooseExpressionType,
                                          ),
                                          CreateExpressionIcon(
                                            expressionType: ExpressionType.link,
                                            currentExpressionType:
                                                currentExpressionType,
                                            switchExpressionType:
                                                chooseExpressionType,
                                          ),
                                          CreateExpressionIcon(
                                            expressionType:
                                                ExpressionType.photo,
                                            currentExpressionType:
                                                currentExpressionType,
                                            switchExpressionType:
                                                chooseExpressionType,
                                          ),
                                          CreateExpressionIcon(
                                            expressionType:
                                                ExpressionType.audio,
                                            currentExpressionType:
                                                currentExpressionType,
                                            switchExpressionType:
                                                chooseExpressionType,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateExpressionIcon extends StatelessWidget {
  const CreateExpressionIcon({
    this.expressionType,
    this.currentExpressionType,
    this.switchExpressionType,
  });

  final ExpressionType expressionType;
  final ExpressionType currentExpressionType;
  final Function switchExpressionType;

  Map<String, dynamic> expressionTypeTraits(BuildContext context) {
    String expressionTypeText;
    Icon expressionTypeIcon;

    Color color;
    if (currentExpressionType == expressionType) {
      color = Theme.of(context).primaryColorDark;
    } else {
      color = Theme.of(context).primaryColorLight;
    }

    switch (expressionType) {
      case ExpressionType.dynamic:
        expressionTypeText = 'DYNAMIC';
        expressionTypeIcon = Icon(
          CustomIcons.pen,
          size: 33,
          color: color,
        );
        break;
      case ExpressionType.shortform:
        expressionTypeText = 'SHORTFORM';
        expressionTypeIcon = Icon(
          CustomIcons.feather,
          size: 20,
          color: color,
        );
        break;
      case ExpressionType.link:
        expressionTypeText = 'LINK';
        expressionTypeIcon = Icon(
          Icons.link,
          size: 24,
          color: color,
        );
        break;
      case ExpressionType.photo:
        expressionTypeIcon = Icon(
          CustomIcons.camera,
          size: 20,
          color: color,
        );
        expressionTypeText = 'PHOTO';
        break;
      case ExpressionType.audio:
        expressionTypeIcon = Icon(
          Icons.mic,
          size: 20,
          color: color,
        );
        expressionTypeText = 'AUDIO';
        break;

      default:
        expressionTypeText = 'DYNAMIC';
        expressionTypeIcon = Icon(
          CustomIcons.pen,
          size: 36,
          color: color,
        );
        break;
    }

    return {
      'expressionTypeText': expressionTypeText,
      'expressionTypeIcon': expressionTypeIcon,
      'color': color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => switchExpressionType(expressionType),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 38,
                child: expressionTypeTraits(context)['expressionTypeIcon'],
              ),
              const SizedBox(height: 5),
              Text(expressionTypeTraits(context)['expressionTypeText'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: expressionTypeTraits(context)['color'],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
