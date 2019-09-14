import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/bullet/bullet.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_bottom_nav.dart';
import 'package:junto_beta_mobile/screens/create/event/event.dart';
import 'package:junto_beta_mobile/screens/create/longform/longform.dart';
import 'package:junto_beta_mobile/screens/create/photo/photo.dart';
import 'package:junto_beta_mobile/screens/create/shortform/shortform.dart';
import 'package:junto_beta_mobile/typography/style.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';


class JuntoCreate extends StatefulWidget {
  const JuntoCreate(this.expressionLayer);

  final String expressionLayer;

  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  String _expressionType = 'Storyform';
  bool _longform = true;
  bool _shortform = false;
  bool _bullet = false;
  bool _photo = false;
  bool _events = false;
  bool _bottomNavVisible = true;
  ValueNotifier<bool> isEditing;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isEditing = ValueNotifier<bool>(false);
    isEditing.addListener(() {
      print('user is editing');
    });
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
        isEditing: isEditing,
      );
    } else if (_shortform) {
      return CreateShortform(
        isEditing: isEditing,
      );
    } else if (_bullet) {
      return CreateBullet();
    } else if (_photo) {
      return CreatePhoto(
        toggleBottomNavVisibility: _toggleBottomNavVisibility,
        isEditing: isEditing,
      );
    } else if (_events) {
      return CreateEvent(
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
  void confirmSwitch(String templateType) {
    if (isEditing.value == true || formKey.currentState?.validate() == true) {
      JuntoDialog.showJuntoDialog(
        context,
        'Junto',
        'Are you sure you would like to switch Expression?',
        <Widget>[
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              switchTemplate(templateType);
            },
          ),
          FlatButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      switchTemplate(templateType);
    }
  }

// Switch between different expression templates
  void switchTemplate(String templateType) {
    // Reset State
    _resetState();

    // Update expression type
    _expressionType = templateType;

    // Update state
    if (templateType == 'longform') {
      setState(() {
        _longform = true;
      });
    } else if (templateType == 'shortform') {
      setState(() {
        _shortform = true;
      });
    } else if (templateType == 'bullet') {
      setState(() {
        _bullet = true;
      });
    } else if (templateType == 'photo') {
      setState(() {
        _photo = true;
      });
    } else if (templateType == 'events') {
      setState(() {
        _events = true;
      });
    } else {
      print('not an expresion type');
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
                      _expressionType.toLowerCase(),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => CreateActions(
                              expressionLayer: widget.expressionLayer,
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: JuntoPalette.juntoGrey,
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
