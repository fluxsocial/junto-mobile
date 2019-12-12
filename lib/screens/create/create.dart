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
  bool _longform = true;
  bool _shortform = false;
  bool _photo = false;
  bool _events = false;

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
        key: _photoFormKey,
        toggleBottomNavVisibility: () {},
      );
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

    Navigator.pop(context);
  }

  void _onNextClick() {
    print(widget.expressionContext);
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return CreateActions(
            expressionType: _expressionType,
            address: widget.address,
            channels: widget.channels,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                  child:
                      Text('next', style: Theme.of(context).textTheme.caption),
                )
              ],
            ),
          ),
        ),
      ),
      endDrawer: const JuntoDrawer(screen: 'Create', icon: CustomIcons.create),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          screen: 'create',
          onTap: _openExpressionCenter,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: <Widget>[
          _buildTemplate(),
        ],
      ),
    );
  }

  void _openExpressionCenter() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ExpressionCenter(
          switchView: switchTemplate,
        );
      },
    );
  }
}

class ExpressionCenter extends StatelessWidget {
  const ExpressionCenter({
    Key key,
    @required this.switchView,
  }) : super(key: key);
  final ValueChanged<String> switchView;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .3,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: Text('Expression Center',
                      style: Theme.of(context).textTheme.title),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        switchView('LongForm');
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width * .25,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              CustomIcons.longform,
                              size: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(height: 5),
                            Text('dynamic',
                                style: Theme.of(context).textTheme.subtitle)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        switchView('ShortForm');
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        width: MediaQuery.of(context).size.width * .25,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              CustomIcons.feather,
                              size: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(height: 5),
                            Text('shortform',
                                style: Theme.of(context).textTheme.subtitle)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        switchView('PhotoForm');
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        width: MediaQuery.of(context).size.width * .25,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              CustomIcons.camera,
                              size: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(height: 5),
                            Text('photo',
                                style: Theme.of(context).textTheme.subtitle)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        switchView('EventForm');
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        width: MediaQuery.of(context).size.width * .25,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              CustomIcons.event,
                              size: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(height: 5),
                            Text('event',
                                style: Theme.of(context).textTheme.subtitle)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
