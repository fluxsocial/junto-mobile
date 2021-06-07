import 'dart:async';
import 'package:dio/dio.dart';
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/app/community_center_addresses.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/channel_search_modal.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/sphere_select_modal.dart';
import 'package:junto_beta_mobile/screens/groups/circles/circles.dart';
import 'package:provider/provider.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionType,
    @required this.expressionContext,
    @required this.expression,
    @required this.mentions,
    @required this.address,
    @required this.channels,
  }) : super(key: key);

  /// Represents the type of expression being created. Possible values include
  /// "LongForm", "ShortForm", "EventForm", etc
  final ExpressionType expressionType;

  /// This represents the Expression's context. Please see [ExpressionContext]
  final ExpressionContext expressionContext;

  /// Represents the expression data. Value depends on the type of expression
  /// being created.
  final dynamic expression;

  // List of mentions [uuids]
  final List<String> mentions;

  // List of channels [name]
  final List<String> channels;

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

  // community center address
  final String communityCenterAddress = kCommunityCenterAddress;

  String _currentExpressionContext;
  ExpressionContext _expressionContext;
  String _currentExpressionContextDescription;

  String _address;
  ExpressionModel _expression;
  final ValueNotifier<List<String>> _channels = ValueNotifier<List<String>>(
    <String>[],
  );

  List<String> _channelsList = [];

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  List<String> get channel => _channels.value;

  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  // relation to community center
  Map<String, dynamic> relationToGroup;

  // group handle
  String _groupHandle = 'share to a specific circle';

  @override
  void initState() {
    super.initState();
    print(widget.expressionContext);
    _channelsList = widget.channels;
    _channels.value = widget.channels;
    _channelController = TextEditingController();
    _address = widget.address;
    _expressionContext = widget.expressionContext;
    if (widget.expressionContext == ExpressionContext.Collective) {
      _currentExpressionContext = 'Collective';
      _currentExpressionContextDescription = 'share publicly on Junto';
    } else if (widget.expressionContext == ExpressionContext.Group &&
        widget.address != communityCenterAddress) {
      _currentExpressionContext = 'My Pack';
      _currentExpressionContextDescription = 'share to just your Pack members';
    } else if (widget.expressionContext == ExpressionContext.Group &&
        widget.address == communityCenterAddress) {
      _currentExpressionContext = 'Community Center';
      _currentExpressionContextDescription =
          'share your feedback with the team and community';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userAddress = Provider.of<UserDataProvider>(context).userAddress;
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => Provider.of<GroupRepo>(context).getUserGroups(_userAddress),
    );
  }

  void _postCreateAction() {
    Widget child;
    if (_expressionContext == ExpressionContext.Collective) {
      context.read<CollectiveBloc>().add(RefreshCollective());
      child = JuntoCollective();
    } else if (_expressionContext == ExpressionContext.Group &&
        _currentExpressionContext == 'Circles') {
      child = FeatureDiscovery(
        child: Circles(),
      );
    } else {
      context.read<CollectiveBloc>().add(
            RefreshCollective(),
          );
      child = JuntoCollective();
    }

    Navigator.of(context).pushAndRemoveUntil(
      FadeRoute<void>(child: child),
      (Route<dynamic> route) {
        return route.isFirst;
      },
    );
  }

  Future<ExpressionModel> getPhotoExpression(ExpressionRepo repository) async {
    final image = widget.expression['image'];

    final photoKeys = await repository.createPhotoThumbnails(image);

    return ExpressionModel(
      type: widget.expressionType.modelName(),
      expressionData: PhotoFormExpression(
        image: photoKeys.keyPhoto,
        caption: widget.expression['caption'],
        thumbnail300: photoKeys.key300,
        thumbnail600: photoKeys.key600,
      ).toJson(),
      context: _expressionContext,
      channels: channel,
      mentions: widget.mentions,
    );
  }

  Future<ExpressionModel> getAudioExpression(ExpressionRepo repository) async {
    final audio = widget.expression as AudioFormExpression;
    final AudioFormExpression expression = await repository.createAudio(audio);

    return ExpressionModel(
      type: widget.expressionType.modelName(),
      expressionData: expression.toJson(),
      context: _expressionContext,
      channels: channel,
      mentions: widget.mentions,
    );
  }

  Future<void> _createExpression() async {
    try {
      final repository = Provider.of<ExpressionRepo>(context, listen: false);
      switch (widget.expressionType) {
        case ExpressionType.photo:
          JuntoLoader.showLoader(context, color: Colors.white54);
          _expression = await getPhotoExpression(repository);
          JuntoLoader.hide();
          break;
        case ExpressionType.audio:
          JuntoLoader.showLoader(context);
          _expression = await getAudioExpression(repository);
          JuntoLoader.hide();
          break;
        default:
          _expression = ExpressionModel(
            type: widget.expressionType.modelName(),
            expressionData: widget.expression.toJson(),
            context: _expressionContext,
            channels: channel,
            mentions: widget.mentions,
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
    } on DioError catch (error) {
      JuntoLoader.hide();

      // Handle max number of posts/day error
      if (error.response.statusCode == 429) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText:
                'You can only post to the Collective 5 times every 24 hours. Please try again soon.',
          ),
        );
      } else if (error.response.data
          .toString()
          .contains('No more than 5 channels allowed')) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
              dialogText: 'You can only add up to 5 channels.'),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.response.data.toString(),
          ),
        );
      }
    } catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void selectGroup(String groupAddress, String groupHandle) {
    setState(() {
      _address = groupAddress;
      _groupHandle = 'share to c/${groupHandle}';
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
                if (widget.address != communityCenterAddress)
                  Container(
                    child: Row(children: <Widget>[
                      const SizedBox(width: 15),
                      _expressionContextSelector(
                          expressionContext: 'Collective'),
                      _expressionContextSelector(expressionContext: 'Circles'),
                      _expressionContextSelector(expressionContext: 'My Pack'),
                    ]),
                  ),
                if (widget.address == communityCenterAddress)
                  Container(
                    child: Row(children: <Widget>[
                      const SizedBox(width: 15),
                      _expressionContextSelector(
                          expressionContext: 'Community Center'),
                      if (relationToGroup != null)
                        if (relationToGroup['creator'] ||
                            relationToGroup['facilitator'])
                          _expressionContextSelector(
                              expressionContext: 'Updates'),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    if (_channelsList == null || _channelsList.isEmpty)
                      Text(
                        '# add channels',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    if (_channelsList == null || _channelsList.isNotEmpty)
                      for (String channel in _channelsList)
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            channel,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expressionContextSelector({String expressionContext}) {
    dynamic _expressionContextIcon;
    Function _setExpressionContextDescription;

    if (expressionContext == 'Collective') {
      _setExpressionContextDescription = () {
        setState(() {
          _expressionContext = ExpressionContext.Collective;
          _currentExpressionContextDescription = 'share publicly on Junto';
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
              'share to just your Pack members';
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
    } else if (expressionContext == 'Circles') {
      _setExpressionContextDescription = () {
        setState(() {
          _expressionContext = ExpressionContext.Group;
          _currentExpressionContextDescription = _groupHandle;
        });
      };
      _expressionContextIcon = Icon(
        CustomIcons.newcircles,
        color: _currentExpressionContext == expressionContext
            ? Colors.white
            : Theme.of(context).primaryColor,
        size: 28,
      );
    } else if (expressionContext == 'Community Center') {
      _setExpressionContextDescription = () {
        setState(() {
          _expressionContext = ExpressionContext.Group;
          _currentExpressionContextDescription =
              'share your feedback with the team and community';
          _address = communityCenterAddress;
        });
      };
      _expressionContextIcon = Image.asset(
        'assets/images/junto-mobile__sprout.png',
        height: 17,
        color: _currentExpressionContext == expressionContext
            ? Colors.white
            : Theme.of(context).primaryColor,
      );
    }
    return GestureDetector(
      onTap: () async {
        // set current expression context
        setState(() {
          _currentExpressionContext = expressionContext;
        });

        // if the context is a sphere, get the user's list of spheres and open
        // the SphereSelectModal
        if (expressionContext == 'Circles') {
          JuntoLoader.showLoader(context);
          final UserGroupsResponse _userGroups =
              await Provider.of<GroupRepo>(context, listen: false)
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              context: context,
              builder: (BuildContext context) {
                return SphereSelectModal(
                  spheres: userSpheres,
                  onSelect: selectGroup,
                );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (BuildContext context) {
        return ChannelSearchModal(
          channels: _channels,
        );
      },
    ).then((x) {
      setState(() {
        _channelsList = _channels.value;
      });
    });
  }
}
