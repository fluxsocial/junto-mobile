import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';

class JuntoCreate extends StatefulWidget {
  const JuntoCreate({
    @required this.channels,
    @required this.address,
    @required this.expressionContext,
  });

  final List<String> channels;
  final String address;
  final ExpressionContext expressionContext;

  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  String _expressionType = 'LongForm';
  String _expressionTypeDisplay = 'dynamic';
  bool _expressionCenterVisible = true;
  bool _longform = true;
  bool _shortform = false;
  bool _photo = false;
  bool _events = false;

  bool _bottomNavVisible = true;

  Icon _currentIcon;

  ValueNotifier<bool> isEditing;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GlobalKey<CreateLongformState> _longFormKey;
  GlobalKey<CreateShortformState> _shortFormKey;
  GlobalKey<CreatePhotoState> _photoFormKey;
  GlobalKey<CreateEventState> _eventKey;



  @override
  void initState() {
    super.initState();
    isEditing = ValueNotifier<bool>(false);
    _longFormKey = GlobalKey<CreateLongformState>();
    _shortFormKey = GlobalKey<CreateShortformState>();
    _photoFormKey = GlobalKey<CreatePhotoState>();
    _eventKey = GlobalKey<CreateEventState>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentIcon = Icon(CustomIcons.longform,
        color: Theme.of(context).primaryColorDark, size: 17);
  }

  @override
  void dispose() {
    isEditing.dispose();
    super.dispose();
  }


  // Build expression template based off state
  Widget _buildTemplate() {
    if (_longform) {
      return CreateLongform(
        key: _longFormKey,
      );
    } else if (_shortform) {
      return CreateShortform(
        key: _shortFormKey,
      );
    } else if (_photo) {
      return CreatePhoto(
          key: _photoFormKey, setBottomNav: _setBottomNavVisibility);
    } else if (_events) {
      return CreateEvent(
        key: _eventKey,
        formKey: formKey,
      );
    } else {
      return Container();
    }
  }

  // Reset all values in state to false
  void _resetState() {
    setState(() {
      _longform = false;
      _shortform = false;
      _photo = false;
      _events = false;
    });
  }

// Switch between different expression templates
  void switchTemplate(String templateType) {
    // Reset State
    _resetState();

    // Update expression type
    _expressionType = templateType;

    // Update state
    if (templateType == 'LongForm' || templateType == 'dynamic') {
      setState(() {
        _longform = true;
        _currentIcon = Icon(CustomIcons.longform,
            color: Theme.of(context).primaryColorDark, size: 17);
        _expressionTypeDisplay = 'dynamic';
      });
    } else if (templateType == 'ShortForm') {
      setState(() {
        _shortform = true;
        _currentIcon = Icon(CustomIcons.feather,
            color: Theme.of(context).primaryColorDark, size: 17);
        _expressionTypeDisplay = 'shortform';
      });
    } else if (templateType == 'PhotoForm') {
      setState(() {
        _photo = true;
        _currentIcon = Icon(CustomIcons.camera,
            color: Theme.of(context).primaryColorDark, size: 17);
        _expressionTypeDisplay = 'photo';
      });
    } else if (templateType == 'EventForm') {
      setState(() {
        _events = true;
        _currentIcon = Icon(CustomIcons.event,
            color: Theme.of(context).primaryColorDark, size: 17);
        _expressionTypeDisplay = 'event';
      });
    } else {
      print('not an expresion type');
    }

    setState(() {
      _expressionCenterVisible = false;
    });
    // Navigator.pop(context);
  }

  void _onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return CreateActions(
            expressionType: _expressionType,
            address: widget.address,
            expressionContext: widget.expressionContext,
            expression: getExpression(),
          );
        },
      ),
    );
  }

  dynamic getExpression() {
    if (_expressionType == 'LongForm') {
      return _longFormKey.currentState.createExpression();
    }
    if (_expressionType == 'ShortForm') {
      return _shortFormKey.currentState.createExpression();
    }

    if (_expressionType == 'PhotoForm') {
      return _photoFormKey.currentState.createExpression();
    }
    if (_expressionType == 'EventForm') {
      return _eventKey.currentState.createExpression();
    }
  }

  void _setBottomNavVisibility(bool visibility) {
    setState(() {
      _bottomNavVisible = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: AppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.light,
              actions: <Widget>[Container()],
              iconTheme: const IconThemeData(color: JuntoPalette.juntoGrey),
              elevation: 0,
              titleSpacing: 0,
              title: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: JuntoStyles.horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _currentIcon,
                        const SizedBox(width: 7.5),
                        Text(_expressionTypeDisplay,
                            style: Theme.of(context).textTheme.caption)
                      ],
                    ),
                    GestureDetector(
                      onTap: _onNextClick,
                      child: Text('next',
                          style: Theme.of(context).textTheme.caption),
                    )
                  ],
                ),
              ),
            ),
          ),
          endDrawer:
              const JuntoDrawer(screen: 'Create', icon: CustomIcons.create),
          floatingActionButton:
              _bottomNavVisible && MediaQuery.of(context).viewInsets.bottom == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: BottomNav(
                        screen: 'create',
                        onTap: () {
                          setState(() {
                            _expressionCenterVisible = true;
                          });
                        },
                      ),
                    )
                  : const SizedBox(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Column(
            children: <Widget>[
              _buildTemplate(),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _expressionCenterVisible ? 1.0 : 0.0,
          child:
              _expressionCenterVisible ? _expressionCenter() : const SizedBox(),
        )
      ],
    );
  }

  Widget _expressionCenter() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.2, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.secondaryVariant,
            Theme.of(context).colorScheme.primaryVariant
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _selectExpression('dynamic'),
                    _selectExpression('shortform'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _selectExpression('photo'),
                    _selectExpression('event'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  height: 50,
                  width: 50,
                  child: Icon(CustomIcons.lotus, size: 32, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _selectExpression(String expressionType) {
    String expressionName;
    Widget expressionIcon;
    Function switchExpression;
    if (expressionType == 'dynamic') {
      expressionName = 'DYNAMIC';
      expressionIcon = Icon(CustomIcons.longform,
          color: Theme.of(context).dividerColor, size: 24);
      switchExpression = () {
        switchTemplate('LongForm');
      };
    } else if (expressionType == 'shortform') {
      expressionName = 'SHORTFORM';
      expressionIcon = Icon(CustomIcons.feather,
          color: Theme.of(context).dividerColor, size: 24);
      switchExpression = () {
        switchTemplate('ShortForm');
      };
    } else if (expressionType == 'photo') {
      expressionName = 'PHOTO';
      expressionIcon = Icon(CustomIcons.camera,
          color: Theme.of(context).dividerColor, size: 24);
      switchExpression = () {
        switchTemplate('PhotoForm');
      };
    } else if (expressionType == 'event') {
      expressionName = 'EVENT';
      expressionIcon = Icon(CustomIcons.event,
          color: Theme.of(context).dividerColor, size: 24);
      switchExpression = () {
        switchTemplate('EventForm');
      };
    }
    return GestureDetector(
      onTap: switchExpression,
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                child: expressionIcon),
            const SizedBox(height: 2.5),
            Text(
              expressionName,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
