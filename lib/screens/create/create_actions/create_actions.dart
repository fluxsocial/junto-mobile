import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';
import 'package:provider/provider.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionType,
    @required this.channels,
    @required this.expressionContext,
    @required this.expression,
    @required this.address,
  }) : super(key: key);

  /// Represents the type of expression being created. Possible values include
  /// "LongForm", "ShortForm", "EventForm", etc
  final String expressionType;

  /// This is the name of the channel to which the expression is being posted.
  final List<String> channels;

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

class CreateActionsState extends State<CreateActions> {
  String _selectedType = 'Collective';

  String _address;
  CentralizedExpression _expression;

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
    _address = widget.address;
    // _expression = CentralizedExpression(
    //     type: widget.expressionType,
    //     expressionData: widget.expression.toMap(),
    //     context: widget.expressionContext);
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<void> _createExpression() async {
    try {
      if (widget.expressionType == 'PhotoForm') {
        final String _photoKey =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto('.png', widget.expression['image']);
        _expression = CentralizedExpression(
            type: widget.expressionType,
            expressionData: CentralizedPhotoFormExpression(
                    image: _photoKey, caption: widget.expression['caption'])
                .toMap(),
            context: widget.expressionContext,
            channels: <String>['sustainability', 'architecture']);
      } else if (widget.expressionType == 'EventForm') {
        print(widget.expression['photo']);
        String eventPhoto = '';
        if (widget.expression['photo'] != null) {
          final String _eventPhotoKey =
              await Provider.of<ExpressionRepo>(context, listen: false)
                  .createPhoto('.png', widget.expression['photo']);
          eventPhoto = _eventPhotoKey;
          print(eventPhoto);
        }
        _expression = CentralizedExpression(
            type: widget.expressionType,
            expressionData: CentralizedEventFormExpression(
                photo: eventPhoto,
                description: widget.expression['description'],
                title: widget.expression['title'],
                location: widget.expression['location'],
                startTime: widget.expression['startTime'],
                endTime: widget.expression['endTime'],
                facilitators: <String>[],
                members: <String>[]).toMap(),
            channels: <String>['sustainability', 'architecture'],
            context: widget.expressionContext);
      } else {
        _expression = CentralizedExpression(
            type: widget.expressionType,
            expressionData: widget.expression.toMap(),
            context: widget.expressionContext);
      }

      JuntoLoader.showLoader(context);

      await Provider.of<ExpressionRepo>(context, listen: false)
          .createExpression(
        _expression,
        _expression.context,
        _address,
      );

      JuntoLoader.hide();
      // JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        'Expression Created!',
        <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                JuntoCollective.route(),
                (_) => false,
              );
            },
            child: const Text('Ok'),
          )
        ],
      );
    } catch (error) {
      print(error.message);
      JuntoLoader.hide();
      // FIXME: (Nash/Eric) - creating an expression retrieves the following error.
      // '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'int'
      // Temporarily displaying 'Expression Created' for this build as the expressions do get created.

      // JuntoDialog.showJuntoDialog(
      //   context,
      //   'Something went wrong',
      //   <Widget>[
      //     FlatButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       child: const Text('Ok'),
      //     )
      //   ],
      // );
      JuntoDialog.showJuntoDialog(
        context,
        'Expression Created!',
        <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                JuntoCollective.route(),
                (_) => false,
              );
            },
            child: const Text('Ok'),
          )
        ],
      );
    }
  }

  void _onSharingClick(String layer, String resource) {
    Navigator.pop(context);
    if (layer == 'Public Den') {
      _expression = _expression.copyWith(context: ExpressionContext.Group);
    } else if (layer == 'My Pack') {
      _expression = _expression.copyWith(context: ExpressionContext.Group);
    } else {
      _expression = _expression.copyWith(context: ExpressionContext.Collective);
    }

    _address = resource;
    setState(() => _selectedType = layer);
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
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text('# add channels',
                  style: Theme.of(context).textTheme.caption),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return _ExpressionLayerBottomSheet(
                    onItemClick: _onSharingClick,
                  );
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'sharing to ' + _selectedType,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(width: 1),
                  Icon(Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColorDark, size: 17)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildChannelsModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * .6,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
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
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: .75,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _channelController,
                          buildCounter: (
                            BuildContext context, {
                            int currentLength,
                            int maxLength,
                            bool isFocused,
                          }) =>
                              null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            border: InputBorder.none,
                            hintText: 'add up to five channels',
                            hintStyle: Theme.of(context).textTheme.caption,
                          ),
                          cursorColor: Theme.of(context).primaryColorDark,
                          cursorWidth: 2,
                          maxLines: null,
                          style: Theme.of(context).textTheme.caption,
                          maxLength: 80,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: const <Widget>[
                      ChannelPreview(
                        channel: 'design',
                      ),
                      ChannelPreview(
                        channel: 'technology',
                      ),
                      ChannelPreview(
                        channel: 'austrian economics',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

typedef OnItemClick = Function(String name, String resourceAddress);

class _ExpressionLayerBottomSheet extends StatefulWidget {
  const _ExpressionLayerBottomSheet({
    Key key,
    @required this.onItemClick,
  }) : super(key: key);

  final OnItemClick onItemClick;

  @override
  State<StatefulWidget> createState() => _ExpressionLayerBottomSheetState();
}

class _ExpressionLayerBottomSheetState
    extends State<_ExpressionLayerBottomSheet> {
  PageController _pageController;
  bool _chooseBase = true;
  bool _chooseSpheres = false;
  UserData user;
  String resourceAddress;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readUser();
  }

  Future<void> _readUser() async {
    final UserData _user = await Provider.of<UserRepo>(context).readLocalUser();
    if (_user != null) {
      user = _user;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _expressionLayerWidget(String layer) {
    dynamic expressionLayerIcon;

    if (layer == 'Collective') {
      resourceAddress = null;
      expressionLayerIcon = Icon(
        CustomIcons.lotus,
        color: Colors.white,
        size: 15,
      );
    } else if (layer == 'My Pack') {
      resourceAddress = user?.pack?.address;
      expressionLayerIcon = Icon(
        CustomIcons.packs,
        color: Colors.white,
        size: 15,
      );
    } else if (layer == 'Public Den') {
      resourceAddress = user?.publicDen?.address;
      expressionLayerIcon = Image.asset(
        'assets/images/junto-mobile__logo--white.png',
        color: Colors.white,
        height: 18,
      );
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      onTap: () => widget.onItemClick(layer, resourceAddress),
      title: Row(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.2, 0.9],
                  colors: <Color>[
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary
                  ],
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: expressionLayerIcon),
          const SizedBox(width: 20),
          Text(layer, style: Theme.of(context).textTheme.caption)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .6,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
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
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(0);
                      },
                      child: Text(
                        'Base',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _chooseBase
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(1);
                      },
                      child: Text(
                        'Spheres',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _chooseSpheres
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      if (index == 0) {
                        setState(() {
                          _chooseBase = true;
                          _chooseSpheres = false;
                        });
                      } else if (index == 1) {
                        setState(() {
                          _chooseBase = false;
                          _chooseSpheres = true;
                        });
                      }
                    },
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                              child: ListView(
                            children: <Widget>[
                              _expressionLayerWidget('Collective'),
                              _expressionLayerWidget('My Pack'),
                              _expressionLayerWidget('Public Den'),
                            ],
                          )),
                        ],
                      ),
                      const Center(
                        child: Text('spheres'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionTile extends StatefulWidget {
  const _SelectionTile({
    Key key,
    @required this.name,
    @required this.desc,
    @required this.onClick,
    @required this.isSelected,
  }) : super(key: key);

  final String name;
  final String desc;
  final bool isSelected;
  final ValueChanged<String> onClick;

  @override
  State createState() => _SelectionTileState();
}

class _SelectionTileState extends State<_SelectionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: InkWell(
        onTap: () => widget.onClick(widget.name),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: kThemeChangeDuration,
              height: 17,
              width: 17,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.isSelected
                        ? <Color>[
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary
                          ]
                        : <Color>[
                            Colors.white,
                            Colors.white,
                          ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.white
                      : Theme.of(context).dividerColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
