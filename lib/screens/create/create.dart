import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/bullet/bullet.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';

class JuntoCreate extends StatefulWidget {
  const JuntoCreate(this.expressionLayer, {this.address});

  final String expressionLayer;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  String _expressionType = 'LongForm';
  bool _longform = true;
  bool _shortform = false;
  bool _bullet = false;
  bool _photo = false;
  bool _events = false;

  Icon _currentIcon = const Icon(CustomIcons.longform, color: Colors.white);

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
  void dispose() {
    isEditing.dispose();
    super.dispose();
  }

  // Build expression template based off state
  Widget _buildTemplate() {
    if (_longform) {
      return CreateLongform(
        key: _longFormKey,
        isEditing: isEditing,
      );
    } else if (_shortform) {
      return CreateShortform(
        key: _shortFormKey,
        isEditing: isEditing,
      );
    } else if (_bullet) {
      return CreateBullet();
    } else if (_photo) {
      return CreatePhoto(
        key: _photoFormKey,
        toggleBottomNavVisibility: () {},
        isEditing: isEditing,
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
      _bullet = false;
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
        _currentIcon =
            const Icon(CustomIcons.longform, color: Colors.white, size: 20);
      });
    } else if (templateType == 'ShortForm') {
      setState(() {
        _shortform = true;
        _currentIcon =
            const Icon(CustomIcons.feather, color: Colors.white, size: 20);
      });
    } else if (templateType == 'BulletForm') {
      setState(() {
        _bullet = true;
      });
    } else if (templateType == 'PhotoForm') {
      setState(() {
        _photo = true;
        _currentIcon =
            const Icon(CustomIcons.camera, color: Colors.white, size: 20);
      });
    } else if (templateType == 'EventForm') {
      setState(() {
        _events = true;
        _currentIcon =
            const Icon(CustomIcons.event, color: Colors.white, size: 20);
      });
    } else {
      print('not an expresion type');
    }

    Navigator.pop(context);
  }

  void _onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return CreateActions(
            address: widget.address,
            expressionLayer: widget.expressionLayer,
            expressionType: _expressionType,
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
    if (_expressionType == 'BulletForm') {
      return null;
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoGrey),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: JuntoStyles.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff333333),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _onNextClick,
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: JuntoPalette.juntoSleek,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Opacity(
        opacity: .8,
        child: GestureDetector(
          onTap: () {
            _openExpressionCenter();
          },
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: <double>[0.1, 0.9],
                colors: <Color>[
                  JuntoPalette.juntoSecondary,
                  JuntoPalette.juntoPrimary,
                ],
              ),
            ),
            child: _currentIcon,
          ),
        ),
      ),
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
      color: const Color(0xff737373),
      child: Container(
        height: MediaQuery.of(context).size.height * .3,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
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
                          color: const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    'Expression Center',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            switchTemplate('LongForm');
                          },
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width * .25,
                            child: Column(
                              children: <Widget>[
                                const Icon(
                                  CustomIcons.longform,
                                  size: 20,
                                  color: Color(0xff555555),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'dynamic',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff555555),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            switchTemplate('ShortForm');
                          },
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * .25,
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  CustomIcons.feather,
                                  size: 20,
                                  color: Color(0xff555555),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'shortform',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff555555)),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            switchTemplate('PhotoForm');
                          },
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * .25,
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  CustomIcons.camera,
                                  size: 20,
                                  color: Color(0xff555555),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'photo',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff555555)),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            switchTemplate('EventForm');
                          },
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * .25,
                            child: Column(
                              children: const <Widget>[
                                Icon(
                                  CustomIcons.event,
                                  size: 20,
                                  color: Color(0xff555555),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'event',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff555555)),
                                )
                              ],
                            ),
                          ),
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
    );
  }
}
