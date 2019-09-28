import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/bullet/bullet.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_bottom_nav.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/styles.dart';

class JuntoCreate extends StatefulWidget {
  const JuntoCreate(this.expressionLayer);

  final String expressionLayer;

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
  bool _bottomNavVisible = true;
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

  void _toggleBottomNavVisibility() {
    if (_bottomNavVisible) {
      setState(() {
        _bottomNavVisible = false;
      });
    } else {
      setState(() {
        _bottomNavVisible = true;
      });
    }
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
        toggleBottomNavVisibility: _toggleBottomNavVisibility,
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

  /// Ask for user confirmation to switch between expressions if field is no
  /// empty
  // void confirmSwitch(String templateType) {
  //   if (isEditing.value == true || formKey.currentState?.validate() == true) {
  //     JuntoDialog.showJuntoDialog(
  //       context,
  //       'Are you sure you want to switch expressions?',
  //       <Widget>[
  //         FlatButton(
  //           child: const Text(
  //             'Yes',
  //           ),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             switchTemplate(templateType);
  //           },
  //         ),
  //         FlatButton(
  //           child: const Text(
  //             'No',
  //           ),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     );
  //   } else {
  //     switchTemplate(templateType);
  //   }
  // }

  void confirmSwitch(String templateType) {
    switchTemplate(templateType);
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
      });
    } else if (templateType == 'ShortForm') {
      setState(() {
        _shortform = true;
      });
    } else if (templateType == 'BulletForm') {
      setState(() {
        _bullet = true;
      });
    } else if (templateType == 'PhotoForm') {
      setState(() {
        _photo = true;
      });
    } else if (templateType == 'EventForm') {
      setState(() {
        _events = true;
      });
    } else {
      print('not an expresion type');
    }
  }

  void _onNextClick() {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return CreateActions(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 30.0,
                        width: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _expressionType == 'LongForm'
                          ? 'dynamic'
                          : _expressionType.toLowerCase(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff333333),
                      ),
                    ),
                  ],
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
      body: Column(
        children: <Widget>[
          _buildTemplate(),
        ],
      ),
      bottomNavigationBar: CreateBottomNav(confirmSwitch, _bottomNavVisible),
    );
  }
}
