import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/channel_search_modal.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/sphere_select_modal.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/groups/groups.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/user_feedback.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionType,
    @required this.expressionContext,
    @required this.expression,
    @required this.address,
  }) : super(key: key);

  /// Represents the type of expression being created. Possible values include
  /// "LongForm", "ShortForm", "EventForm", etc
  final ExpressionType expressionType;

  /// This represents the Expression's context. Please see [ExpressionContext]
  final ExpressionContext expressionContext;

  /// Represents the expression data. Value depends on the type of expression
  /// being created.
  final dynamic expression;

  /// Address of the [Group] or collection to which the expression is being posted.
  /// Can also be null if the [expressionContext] == [ExpressionContext.Collective]
  final String address;

  @override
  State<StatefulWidget> createState() => CreateActionsState();
}

class CreateActionsState extends State<CreateActions> with ListDistinct {
  // user information
  String _userAddress;
  UserData _userProfile;

  //
  String _currentExpressionContext = 'Collective';
  ExpressionContext _expressionContext;
  String _currentExpressionContextDescription = 'shared to the public of Junto';

  String _address;
  ExpressionModel _expression;
  String _groupHandle = 'shared to a specific group';
  final ValueNotifier<List<String>> _channels = ValueNotifier<List<String>>(
    <String>[],
  );

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  List<String> get channel => _channels.value;

  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
    _address = widget.address;
    _expressionContext = widget.expressionContext;

    getUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => Provider.of<UserRepo>(context).getUserGroups(_userAddress),
    );
  }

  void _postCreateAction() {
    Widget child;
    if (_currentExpressionContext == 'Collective') {
      child = JuntoCollective();
    } else if (_currentExpressionContext == 'My Pack') {
      child = JuntoGroups(initialGroup: _address);
    } else if (_currentExpressionContext == 'Sphere') {
      child = JuntoGroups(initialGroup: _address);
    } else {
      child = JuntoDen();
    }
    Navigator.of(context).pushAndRemoveUntil(
      FadeRoute<void>(child: child),
      (Route<dynamic> route) {
        return route.isFirst;
      },
    );
  }

  Future<void> _createExpression() async {
    await showFeedback(
      context,
      icon: Container(
        margin: const EdgeInsets.only(
          right: 20,
        ),
        child: Icon(
          CustomIcons.create,
          size: 17,
          color: Theme.of(context).primaryColor,
        ),
      ),
      message: 'Expression Created!',
      color: Theme.of(context).backgroundColor,
      fontColor: Theme.of(context).primaryColor,
    );
    // // set expression context
    // _setExpressionContext();

    // try {
    //   if (widget.expressionType == ExpressionType.photo) {
    //     JuntoLoader.showLoader(context);
    //     final String _photoKey =
    //         await Provider.of<ExpressionRepo>(context, listen: false)
    //             .createPhoto(
    //       true,
    //       '.png',
    //       widget.expression['image'],
    //     );
    //     JuntoLoader.hide();
    //     _expression = ExpressionModel(
    //       type: widget.expressionType.modelName(),
    //       expressionData: PhotoFormExpression(
    //         image: _photoKey,
    //         caption: widget.expression['caption'],
    //       ).toMap(),
    //       context: _expressionContext,
    //       channels: channel,
    //     );
    //   } else if (widget.expressionType == ExpressionType.event) {
    //     String eventPhoto = '';
    //     if (widget.expression['photo'] != null) {
    //       JuntoLoader.showLoader(context);
    //       final String _eventPhotoKey =
    //           await Provider.of<ExpressionRepo>(context, listen: false)
    //               .createPhoto(
    //         true,
    //         '.png',
    //         widget.expression['photo'],
    //       );
    //       JuntoLoader.hide();
    //       eventPhoto = _eventPhotoKey;
    //     }
    //     _expression = ExpressionModel(
    //       type: widget.expressionType.modelName(),
    //       expressionData: EventFormExpression(
    //           photo: eventPhoto,
    //           description: widget.expression['description'],
    //           title: widget.expression['title'],
    //           location: widget.expression['location'],
    //           startTime: widget.expression['start_time'],
    //           endTime: widget.expression['end_time'],
    //           facilitators: <String>[],
    //           members: <String>[]).toMap(),
    //       channels: channel,
    //       context: _expressionContext,
    //     );
    //   } else {
    //     _expression = ExpressionModel(
    //       type: widget.expressionType.modelName(),
    //       expressionData: widget.expression.toMap(),
    //       context: _expressionContext,
    //       channels: channel,
    //     );
    //     print(_expression.expressionData);
    //   }
    //   JuntoLoader.showLoader(context);
    //   await Provider.of<ExpressionRepo>(context, listen: false)
    //       .createExpression(
    //     _expression,
    //     _expression.context,
    //     _address,
    //   );
    //   JuntoLoader.hide();
    //   await showFeedback(
    //     context,
    //     message: 'Expression created 🎉',
    //     color: Theme.of(context).backgroundColor,
    //     fontColor: Theme.of(context).primaryColor,
    //   );
    //   _postCreateAction();
    // } catch (error) {
    //   JuntoLoader.hide();
    //   JuntoDialog.showJuntoDialog(
    //     context,
    //     'Something went wrong',
    //     <Widget>[
    //       FlatButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: const Text('Ok'),
    //       )
    //     ],
    //   );
    // }
  }

  void _setExpressionContext() {
    if (_currentExpressionContext == 'Collective') {
      setState(() {
        _expressionContext = ExpressionContext.Collective;
      });
    } else if (_currentExpressionContext == 'Sphere') {
      setState(() {
        _expressionContext = ExpressionContext.Group;
      });
    } else if (_currentExpressionContext == 'My Pack') {
      setState(() {
        _expressionContext = ExpressionContext.Group;
      });
    } else if (_currentExpressionContext == 'Den') {
      setState(() {
        _expressionContext = ExpressionContext.Group;
      });
    }
  }

  void selectGroup(String groupAddress, String groupHandle) {
    setState(() {
      _address = groupAddress;
      _groupHandle = 'shared to s/' + groupHandle;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateActionsAppbar(
          onCreateTap: _createExpression,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15),
                Text(_currentExpressionContext,
                    style: Theme.of(context).textTheme.headline6),
                Text(_currentExpressionContextDescription,
                    style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(children: <Widget>[
                    const SizedBox(width: 15),
                    _expressionContextSelector(expressionContext: 'Collective'),
                    _expressionContextSelector(expressionContext: 'Sphere'),
                    _expressionContextSelector(expressionContext: 'My Pack'),
                  ]),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _buildChannelsModal(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    '# add channels',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expressionContextSelector({String expressionContext, Group sphere}) {
    dynamic _expressionContextIcon;
    Function _setExpressionContextDescription;

    if (expressionContext == 'Collective') {
      _setExpressionContextDescription = () {
        setState(() {
          _currentExpressionContextDescription =
              'shared to the public of Junto';
          _address = null;
        });
      };
      _expressionContextIcon = Transform.translate(
        offset: const Offset(-10, 0),
        child: Icon(CustomIcons.collective,
            color: _currentExpressionContext == expressionContext
                ? Colors.white
                : Theme.of(context).primaryColor,
            size: 10),
      );
    } else if (expressionContext == 'My Pack') {
      _setExpressionContextDescription = () {
        setState(() {
          _currentExpressionContextDescription =
              'shared to just your pack members';
          _address = _userProfile.pack.address;
        });
      };
      _expressionContextIcon = Icon(CustomIcons.packs,
          color: _currentExpressionContext == expressionContext
              ? Colors.white
              : Theme.of(context).primaryColor,
          size: 17);
    } else if (expressionContext == 'Den') {
      _setExpressionContextDescription = () {
        setState(() {
          _currentExpressionContextDescription = 'shared with just yourself';

          _address = _userProfile.privateDen.address;
          print(_address);
        });
      };
      _expressionContextIcon = Icon(CustomIcons.den,
          color: _currentExpressionContext == expressionContext
              ? Colors.white
              : Theme.of(context).primaryColor,
          size: 17);
    } else if (expressionContext == 'Sphere') {
      _setExpressionContextDescription = () {
        setState(() {
          _currentExpressionContextDescription = _groupHandle;
          _address = null;
        });
        print(_address);
      };
      _expressionContextIcon = Icon(CustomIcons.spheres,
          color: _currentExpressionContext == expressionContext
              ? Colors.white
              : Theme.of(context).primaryColor,
          size: 17);
    }

    return GestureDetector(
      onTap: () async {
        // set current expression context
        setState(() {
          _currentExpressionContext = expressionContext;
        });

        // if the context is a sphere, get the user's list of spheres and open
        // the SphereSelectModal
        if (expressionContext == 'Sphere') {
          JuntoLoader.showLoader(context);
          final UserGroupsResponse _userGroups =
              await Provider.of<UserRepo>(context, listen: false)
                  .getUserGroups(_userAddress);
          JuntoLoader.hide();
          final List<Group> ownedGroups = _userGroups.owned;
          final List<Group> associatedGroups = _userGroups.associated;
          final List<Group> userSpheres =
              distinct<Group>(ownedGroups, associatedGroups)
                  .where((Group group) => group.groupType == 'Sphere')
                  .toList();
          if (userSpheres.isNotEmpty) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return SphereSelectModal(
                    spheres: userSpheres, onSelect: selectGroup);
              },
            );
          }
          if (userSpheres.isEmpty) {
            showFeedback(context, message: 'You are not apart of any spheres');
            setState(() {
              _currentExpressionContext = 'Collective';
            });
          }
        }

        _setExpressionContextDescription();
      },
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          gradient: _currentExpressionContext == expressionContext
              ? LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.2, 0.9],
                  colors: <Color>[
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(1000),
          ),
          border: _currentExpressionContext == expressionContext
              ? null
              : Border.all(color: Theme.of(context).primaryColor, width: 1.5),
        ),
        alignment: Alignment.center,
        child: _expressionContextIcon,
      ),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildChannelsModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ChannelSearchModal(
          channels: _channels,
        );
      },
    );
  }
}
