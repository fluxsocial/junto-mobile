import 'dart:async';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/channel_search_modal.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:provider/provider.dart';

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

  String _currentExpressionContext;
  ExpressionContext _expressionContext;
  String _currentExpressionContextDescription;

  String _address;
  ExpressionModel _expression;
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
    if (widget.expressionContext == ExpressionContext.Collective) {
      _currentExpressionContext = 'Collective';
      _currentExpressionContextDescription = 'shared to the public of Junto';
    } else if (widget.expressionContext == ExpressionContext.Group) {
      _currentExpressionContext = 'My Pack';
      _currentExpressionContextDescription = 'shared to just your pack members';
    }
    getUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<void> getUserInformation() async {
    setState(() {
      _userAddress = Provider.of<UserDataProvider>(context).userAddress;
      _userProfile = Provider.of<UserDataProvider>(context).userProfile;
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => Provider.of<GroupRepo>(context).getUserGroups(_userAddress),
    );
  }

  void _postCreateAction() {
    Widget child;
    if (_expressionContext == ExpressionContext.Collective) {
      child = JuntoCollective();
    } else if (_expressionContext == ExpressionContext.Group) {
      child = JuntoPacks(initialGroup: _address);
    } else {
      child = JuntoCollective();
    }
    Navigator.of(context).pushAndRemoveUntil(
      FadeRoute<void>(child: child),
      (Route<dynamic> route) {
        return route.isFirst;
      },
    );
  }

  Future<void> _createExpression() async {
    try {
      final repository = Provider.of<ExpressionRepo>(context, listen: false);
      if (widget.expressionType == ExpressionType.photo) {
        JuntoLoader.showLoader(context);
        final String _photoKey = await repository.createPhoto(
          true,
          '.png',
          widget.expression['image'],
        );
        JuntoLoader.hide();
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          expressionData: PhotoFormExpression(
            image: _photoKey,
            caption: widget.expression['caption'],
          ).toMap(),
          context: _expressionContext,
          channels: channel,
        );
      } else if (widget.expressionType == ExpressionType.event) {
        String eventPhoto = '';
        if (widget.expression['photo'] != null) {
          JuntoLoader.showLoader(context);
          final String _eventPhotoKey = await repository.createPhoto(
            true,
            '.png',
            widget.expression['photo'],
          );
          JuntoLoader.hide();
          eventPhoto = _eventPhotoKey;
        }
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          expressionData: EventFormExpression(
              photo: eventPhoto,
              description: widget.expression['description'],
              title: widget.expression['title'],
              location: widget.expression['location'],
              startTime: widget.expression['start_time'],
              endTime: widget.expression['end_time'],
              facilitators: <String>[],
              members: <String>[]).toMap(),
          channels: channel,
          context: _expressionContext,
        );
      } else if (widget.expressionType == ExpressionType.audio) {
        JuntoLoader.showLoader(context);
        final audio = widget.expression as AudioFormExpression;
        //TODO: handle response from the server
        await repository.createAudio(audio);
        JuntoLoader.hide();
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          //TODO: use _audioKey from s3 bucket
          expressionData: audio.toMap(),
          context: _expressionContext,
          channels: channel,
        );
      } else {
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          expressionData: widget.expression.toMap(),
          context: _expressionContext,
          channels: channel,
        );
      }
      JuntoLoader.showLoader(context);
      await Provider.of<ExpressionRepo>(context, listen: false)
          .createExpression(
        _expression,
        _expression.context,
        _address,
      );
      JuntoLoader.hide();

      await showFeedback(
        context,
        icon: Icon(
          CustomIcons.newcreate,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        message: 'Expression Created!',
      );
      _postCreateAction();
    } catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Something went wrong',
        ),
      );
    }
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
                Text(
                  _currentExpressionContext ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  _currentExpressionContextDescription ?? '',
                  style: Theme.of(context).textTheme.caption,
                ),
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
          _expressionContext = ExpressionContext.Collective;
          _currentExpressionContextDescription =
              'shared to the public of Junto';
          _address = null;
        });
      };
      _expressionContextIcon = Icon(
        CustomIcons.newcollective,
        color: _currentExpressionContext == expressionContext
            ? Colors.white
            : Theme.of(context).primaryColor,
        size: 33,
      );
    } else if (expressionContext == 'My Pack') {
      _setExpressionContextDescription = () {
        setState(() {
          _expressionContext = ExpressionContext.Group;
          _currentExpressionContextDescription =
              'shared to just your pack members';
          _address = _userProfile.pack.address;
        });
      };
      _expressionContextIcon = Icon(
        CustomIcons.newpacks,
        color: _currentExpressionContext == expressionContext
            ? Colors.white
            : Theme.of(context).primaryColor,
        size: 28,
      );
    }
    return GestureDetector(
      onTap: () async {
        // set current expression context
        setState(() {
          _currentExpressionContext = expressionContext;
        });
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
              : Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
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
